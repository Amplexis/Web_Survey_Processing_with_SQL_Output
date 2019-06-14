#!/usr/bin/python
# -*- coding: utf-8 -*-

import codecs
import logging
import pandas as pd
from src.functions import *
from src.settings import *


logging.basicConfig(filename='{}.log'.format(PROJECT), level=logging.DEBUG,
                    format='%(asctime)s:%(levelname)s:%(message)s')

page = 1
master_string = '\n'

master_string = initial_setup(PROJECT, master_string)


with pd.ExcelFile(websheet_path) as xlsx:
    data = pd.read_excel(xlsx, 'Websheet')
    try:
        GeneralContent = pd.read_excel(xlsx, 'GeneralContent')
        general_content_check = True
    except Exception as e:
        general_content_check = False
        print(e)
    try:
        Skips = pd.read_excel(xlsx, 'Skips')
        skips_check = True
    except Exception as e:
        skips_check = False
        print(e)
    try:
        Matrix = pd.read_excel(xlsx, 'Matrix_Tables')
        matrix_check = True
    except Exception as e:
        matrix_check = False
        print(e)

# create a list of the unique sections in this websheet
list_of_sections = data.Section.unique()

# create a list of the unique question blocks in this websheet
lol_block_details = build_list_of_blocks(data)

list_of_blocks = lol_block_details[0]
list_of_block_pairs = lol_block_details[1]
block_list = create_df_blocks(list_of_block_pairs, data)  # All blocks are created here

# The dictionary contains all the base questions as keys, and their dataframe blocks as values
dictionary = dict(zip(list_of_blocks, block_list))

# for base in list_of_blocks:
for i in range(len(list_of_blocks)):
    block = dictionary[list_of_blocks[i]]

    # First thing to do after we have the block to work with, is determine if the section has been added.
    section = check(block.iloc[0, 1])
    section_label = check(block.iloc[0, 2])

    if section not in added_sections_list:
        added_sections_list.append(section)
        section_string = build_insert_section_string(PROJECT, section, section_label, page)
        master_string = update_master_string(section_string, master_string)

    # Check if this block contains a subquestion
    sub = block.Subquestion_label
    if not sub.isnull().values.any():   # SUBQUESTIONS
        simple = False
        # I think I should start by trying to get a list of all the sub_questions from the block
        # all sub questions have question text. So begin by getting the base and inserting Questions and q2pn
        base = list_of_blocks[i]
        instructions = check(block.iloc[0, 3])
        question_number = block.iloc[0, 4]
        question_text = block.iloc[0, 5]
        display_function = block.iloc[0, 8]

        master_string = build_insert_q2pn(PROJECT, page, base, master_string)
        master_string = build_insert_questions(PROJECT, page, section, base, question_text,
                                               display_function, master_string, multi_display_functions_to_include_in_insert_questions)

        # Need to find the sub questions next
        master_string = find_and_insert_sub_questions(PROJECT, page, block, disp_functions_with_no_resp_table,
                                                      master_string)

        mandatory_list = mandatory_check(block, mandatory_list, page)
    else:
        simple = True
        # there are no subquestions, do something else
        # first, extract the basic variables
        instructions = check(block.iloc[0, 3])
        question_number = block.iloc[0, 4]
        question_text = block.iloc[0, 5]
        display_function = block.iloc[0, 8]

        # insert q2pn
        base = list_of_blocks[i]

        master_string = build_insert_q2pn(PROJECT, page, base, master_string)

        # insert into Questions table
        master_string = build_insert_questions(PROJECT, page, section, base, question_text,
                                               display_function, master_string, simple_display_functions_to_include_in_insert_questions)

        # insert into SingleQuestions table
        master_string = insert_single_question(PROJECT, base, display_function,
                                               disp_functions_for_insert_single_question, master_string)

        # create responses table if necessary
        if display_function not in disp_functions_with_no_resp_table:
            master_string = build_response_table(base, master_string)

            # fill response table
            master_string = fill_response_table(base, block, master_string)

        # check and add to mandatory_list if required
        mandatory_list = mandatory_check(block, mandatory_list, page)


    # Start building the Answers table stuff here
    prepare_to_build_question(block, master_string, logging, dict_question_display_function, names)
    logging.debug('dictionary; %s', dict_question_display_function)

    # update page number
    page = update_page_number(page)


# Generate the Answers table
master_string = build_answers_table(names, PROJECT, master_string, dict_question_display_function)

# Create Mandatory table and fill
master_string = build_mandatory_questions_table(mandatory_list, PROJECT, master_string)

# Skips
master_string = build_skips_table(PROJECT, master_string)  # create table
if skips_check:
    master_string = fill_skips_table(Skips, master_string)

# General Content
master_string = build_general_content_table(master_string, PROJECT)
if general_content_check:
    master_string = fill_general_content(GeneralContent, master_string)

# Matrix Tables
if matrix_check:
    master_string = initial_matrix_setup(master_string)
    master_string = process_matrix_tables(Matrix, master_string)

# Disposition log
if SURVEY_TYPE == 'CATI':
    master_string = build_disposition_log_table(PROJECT, master_string)

# Grants
master_string = build_grant_statements(PROJECT, master_string, SURVEY_TYPE)

# Fill Access table with test cases
master_string = fill_access_table_with_test_cases(PROJECT, master_string)

with codecs.open(outfile_path, 'w', 'utf8') as sqlfile:
    sqlfile.write(master_string)
