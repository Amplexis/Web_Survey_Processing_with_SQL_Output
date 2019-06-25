import math
import datetime


def initial_setup(PROJECT, master_string):
    string = (
        'SET NAMES utf8;\n'
        'DROP DATABASE IF EXISTS `{0}`;\n'
        '\n'
        '-- create database\n'
        'CREATE DATABASE IF NOT EXISTS {0}\n'
        'DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;\n'
        '\n'
        '-- use database\n'
        'USE {0};\n'
        '\n'
        '-- -------------------------------------------------------------------------\n'
        '\n'
        '-- Sections Table\n'
        '\n'
        'DROP TABLE IF EXISTS {0}.Section;\n'
        '\n'
        'CREATE TABLE {0}.Sections\n'
        '(\n'
        'language TINYINT UNSIGNED NOT NULL DEFAULT 1,\n'
        'section VARCHAR(25),\n'
        'content TEXT,\n'
        'starts_at TINYINT UNSIGNED NOT NULL DEFAULT 1,\n'
        'PRIMARY KEY (language, section)\n'
        ');\n'
        '-- -------------------------------------------------------------------------\n'
        '-- Questions-to-PageNumber (q2pn) Table\n'
        'DROP TABLE IF EXISTS {0}.q2pn;\n'
        '\n'
        'CREATE TABLE {0}.q2pn\n'
        '(\n'
        'page TINYINT UNSIGNED NOT NULL DEFAULT 1,\n'
        'question VARCHAR(25),\n'
        'PRIMARY KEY (page)\n'
        ');\n'
        '-- -------------------------------------------------------------------------\n'
        '-- Questions Table\n'
        'DROP TABLE IF EXISTS {0}.Questions;\n'
        '\n'
        'CREATE TABLE {0}.Questions\n'
        '(\n'
        'language TINYINT UNSIGNED NOT NULL DEFAULT 1,\n'
        'section VARCHAR(25),\n'
        'page TINYINT UNSIGNED NOT NULL DEFAULT 1,\n'
        'page_text VARCHAR(25),\n'
        'instructions TEXT,\n'
        'question TEXT,\n'
        'responses TEXT,\n'
        'PRIMARY KEY (language, page)\n'
        ');\n'
        '-- -------------------------------------------------------------------------\n'
        '-- -------------------------------------------------------------------------\n'
        '-- Sub Questions  Table\n'
        'DROP TABLE IF EXISTS {0}.SubQuestions;\n'
        'CREATE TABLE {0}.SubQuestions\n'
        '(\n'
        'language TINYINT UNSIGNED NOT NULL DEFAULT 1,\n'
        'page TINYINT UNSIGNED NOT NULL DEFAULT 1,\n'
        'part SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,\n'
        'part_text VARCHAR(10),\n'
        'question TEXT,\n'
        'function VARCHAR(33),\n'
        'responses VARCHAR(24),\n'
        'resp_table VARCHAR(50),\n'
        'has_explain BOOLEAN NOT NULL DEFAULT FALSE,\n'
        'has_other BOOLEAN NOT NULL DEFAULT FALSE, \n'
        'has_text_year BOOLEAN NOT NULL DEFAULT FALSE, \n'
        'response_date DATE DEFAULT 0,\n'
        'PRIMARY KEY (part, language, page)\n'
        ');\n'
        '-- -------------------------------------------------------------------------\n'
        '-- -------------------------------------------------------------------------\n'
        '-- SingleQuestions Table\n'
        'DROP TABLE IF EXISTS {0}.SingleQuestions;\n'
        'CREATE TABLE {0}.SingleQuestions\n'
        '(\n'
        'language TINYINT UNSIGNED NOT NULL DEFAULT 1,\n'
        'question VARCHAR(25) NOT NULL,\n'
        'function TEXT,\n'
        'response TEXT,\n'
        'resp_table VARCHAR(255),\n'
        'value SMALLINT NOT NULL DEFAULT 9999,\n'
        'PRIMARY KEY (language, question, value)\n'
        ');\n'
        '-- -------------------------------------------------------------------------\n'
        '-- -------------------------------------------------------------------------\n'
        '-- Pipeline Table\n'
        'DROP TABLE IF EXISTS {0}.Pipeline;\n'
        'CREATE TABLE {0}.Pipeline\n'
        '(\n'
        'identifier VARCHAR(41),\n'
        'question VARCHAR(25),\n'
        'qsource VARCHAR(25),\n'
        'text TEXT,\n'
        'label TEXT,\n'
        'value SMALLINT,\n'
        'UNIQUE KEY id_value (identifier, question, value)\n'
        ');\n'
        '-- -------------------------------------------------------------------------\n'
        '-- -------------------------------------------------------------------------\n'
        '-- Stack Table\n'
        'DROP TABLE IF EXISTS {0}.Stack;\n'
        'CREATE TABLE {0}.Stack\n'
        '(\n'
        'identifier VARCHAR(41) NOT NULL,\n'
        'position INT UNSIGNED AUTO_INCREMENT,\n'
        'top TINYINT UNSIGNED NOT NULL,\n'
        'PRIMARY KEY (position, identifier, top)\n'
        ');\n'
        '-- -------------------------------------------------------------------------\n'
        '-- -------------------------------------------------------------------------\n\n'
        '-- Access Table\n'
        'DROP TABLE IF EXISTS {0}.Access;\n'
        'CREATE TABLE {0}.Access\n'
        '(\n'
        'auto_id INT UNSIGNED AUTO_INCREMENT,\n'
        'identifier VARCHAR(41),\n'
        "pw_assigned TINYINT UNSIGNED NOT NULL DEFAULT '1',\n"
        "answers_added TINYINT UNSIGNED NOT NULL DEFAULT '1',\n"
        "saved TINYINT UNSIGNED NOT NULL DEFAULT '1',\n"
        "language TINYINT UNSIGNED NOT NULL DEFAULT '1',\n"
        "status ENUM('pending', 'pretest', 'verified', 'finished') NOT NULL DEFAULT 'pending',\n"
        "initial_login TIMESTAMP DEFAULT 0,\n"
        "last_update TIMESTAMP DEFAULT 0 ON UPDATE CURRENT_TIMESTAMP,\n"
        "IP_address TEXT,\n"
        "batch_number MEDIUMINT UNSIGNED NOT NULL DEFAULT '0',\n"
        "PRIMARY KEY(auto_id),\n"
        "INDEX (identifier)\n"
        ");\n\n"
        '-- -------------------------------------------------------------------------\n'
        '-- -------------------------------------------------------------------------\n\n'
        "INSERT INTO Access(identifier, status, pw_assigned) VALUES('default', 'finished', '1');\n\n"

    ).format(PROJECT)
    master_string = update_master_string(string, master_string)
    return master_string


def check(variable):
    if type(variable) == float:
        if math.isnan(variable):
            variable = 'None'
    return variable


def Escape_Characters(text):
    text = str(text)
    text = text.replace("'", "\\'")
    return text


def update_page_number(page):
    page += 1
    return page


def build_list_of_blocks(data):
    return_list = []
    list_of_blocks = []
    tuple_list = []
    for index, row in data.iterrows():
        section = check(row['Section'])
        question_number = check(row['Question_number'])

        block = 'S' + str(section) + 'Q' + str(question_number)

        if block not in list_of_blocks:
            list_of_blocks.append(block)
            new_tuple = (str(section), question_number)
            tuple_list.append(new_tuple)
    return_list.append(list_of_blocks)
    return_list.append(tuple_list)

    return return_list


def create_df_blocks(list_of_block_pairs, data):
    new_list = []
    for i, tuple in enumerate(list_of_block_pairs):
        s, q = tuple[0], tuple[1]

        if type(q) == str:
            exec("block_S{2}Q{1} = data[(data.Question_number == '{1}') & (data.Section == '{2}')]".format(i, q, s))
        else:
            exec("block_S{2}Q{1} = data[(data.Question_number == {1}) & (data.Section == '{2}')]".format(i, q, s))

        exec('new_list.append(block_S{1}Q{0})'.format(q, s))
    return new_list


def update_master_string(new_string, master_string):
    master_string = master_string + new_string
    return master_string


def build_insert_section_string(PROJECT, section, section_label, page):
    section_label = check(section_label)
    if section_label == 'None': section_label = ''
    section_label = Escape_Characters(section_label)
    string = (
        "-- Insert New Section\n"
        "INSERT INTO {0}.Sections (section, content, starts_at, language)\n"
        "VALUES ('{1}', '{2}', '{3}', '1');\n\n"
    ).format(PROJECT, section, section_label, page)
    return string


def build_insert_q2pn(PROJECT, page, base, master_string):
    string = (
        'INSERT INTO {0}.q2pn (page, question)\n'
        "VALUES ('{1}', '{2}');\n\n"
    ).format(PROJECT, page, base)
    master_string = update_master_string(string, master_string)
    return master_string


def build_insert_questions(PROJECT, page, section, base, question_text, display_function, master_string,
                           disp_funct_list):
    # there is a difference between non-subquestion and sub-questions here
    # if sub-questions, DisplayTextArea needs to be included in the Questions insert
    # if not sub-questions, do not include DisplayTextAreaResponse
    if display_function not in disp_funct_list:
        display_function = ''

    question_text = Escape_Characters(question_text)

    string = (
        '-- -- Insert New Question\n'
        'INSERT INTO {0}.Questions (page, section, page_text, question, responses, language)\n'
        "VALUES ('{1}', '{2}', '{3}', '{4}', '{5}', '1');\n\n"
    ).format(PROJECT, page, section, base, question_text, display_function)
    master_string = update_master_string(string, master_string)
    return master_string


# def build_insert_single_questions(base, display_function, resp_tbl_name):
#     return None


def build_response_table(base, master_string):
    string = (
        '-- -------------------------------------------------------------------------\n'
        '-- Response Table {0}_responses\n'
        'DROP TABLE IF EXISTS {0}_responses;\n'
        'CREATE TABLE {0}_responses\n'
        '(\n'
        'sortindex SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,\n'
        'language TINYINT UNSIGNED NOT NULL DEFAULT 1,\n'
        'text TEXT NOT NULL,\n'
        'value SMALLINT NOT NULL DEFAULT 9999,\n'
        'has_explain BOOLEAN NOT NULL DEFAULT FALSE,\n'
        'has_other BOOLEAN NOT NULL DEFAULT FALSE,\n'
        'has_text_year BOOLEAN NOT NULL DEFAULT FALSE, \n'
        'random BOOLEAN NOT NULL DEFAULT FALSE,\n'
        'response_date DATE DEFAULT 0,\n'
        'PRIMARY KEY (sortindex, language)\n'
        ');\n'
        '-- -------------------------------------------------------------------------\n'
    ).format(base)
    master_string = update_master_string(string, master_string)
    return master_string


def insert_single_question(PROJECT, base, displayfunction, lst, master_string):
    if displayfunction in lst:
        resp_table = ''
    else:
        resp_table = base + '_responses'

    string = (
        "-- -- -- Insert New Single Question\n"
        "INSERT INTO {0}.SingleQuestions (question, function, resp_table, language)\n"
        "VALUES('{1}', '{2}', '{3}', '1');\n\n"
    ).format(PROJECT, base, displayfunction, resp_table)
    master_string = update_master_string(string, master_string)
    return master_string


def fill_response_table(base, block, master_string):
    for index, row in block.iterrows():
        answer_text = check(row['Answer_text'])
        answer_text = Escape_Characters(answer_text)

        answer_value = check(row['Answer_value'])
        answer_value = int(answer_value)

        randomize_response = check(row['Randomize_response'])
        has_other = check(row['Has_other'])
        has_explain = check(row['Has_explain'])
        has_text_year = check(row['Has_text_year'])

        has_other = '0' if has_other == 'None' else int(has_other)
        has_explain = '0' if has_explain == 'None' else int(has_explain)
        has_text_year = '0' if has_text_year == 'None' else int(has_text_year)
        randomize_response = '0' if randomize_response == 'None' else int(randomize_response)

        string = (
            '-- Response Table {0}_responses\n'
            'INSERT INTO {0}_responses (text, value, has_other, has_explain, has_text_year, random, language)\n'
            "VALUES ('{1}', '{2}', '{3}', '{4}', '{5}', '{6}', '1');\n\n"
        ).format(base, answer_text, answer_value, has_other, has_explain, has_text_year, randomize_response)
        master_string = update_master_string(string, master_string)

    return master_string


def insert_sub_question(PROJECT, page, sub_label, sub_text, display_function, resp_table, has_explain, has_other,
                        has_text_year, master_string):
    if display_function == 'DisplayTextAreaResponse' or display_function == 'DisplayNothing':
        resp_table = ''

    string = (
        "-- -- -- Insert New SubQuestion\n"
        "INSERT INTO {0}.SubQuestions (page, part_text, question, function, responses, resp_table, has_explain, has_other, has_text_year, language)\n"
        "VALUES ('{1}', '{2}', '{3}', '{4}', '', '{5}', '{6}', '{7}', '{8}', '1');\n\n"
    ).format(PROJECT, page, sub_label, sub_text, display_function, resp_table, has_explain, has_other, has_text_year)
    master_string = update_master_string(string, master_string)

    return master_string


def find_and_insert_sub_questions(PROJECT, page, block, no_resp_tbl_list, master_string):
    list_of_added_sub_questions = []
    list_of_created_response_tables = []

    for index, row in block.iterrows():
        requires_response_table = False
        section = check(row['Section'])
        question_number = check(row['Question_number'])
        sub_question_label = check(row['Subquestion_label'])
        sub_question_text = check(row['Subquestion_text'])
        display_function = check(row['Display_function'])

        response_table = check(row['Response_table'])

        has_explain = check(row['Has_explain'])
        has_explain = '0' if has_explain == 'None' else int(has_explain)

        has_other = check(row['Has_other'])
        has_other = '0' if has_other == 'None' else int(has_other)

        has_text_year = check(row['Has_text_year'])
        has_text_year = '0' if has_text_year == 'None' else int(has_text_year)

        answer_text = check(row['Answer_text'])
        answer_text = Escape_Characters(answer_text)

        answer_value = check(row['Answer_value'])

        randomize_response = check(row['Randomize_response'])
        randomize_response = '0' if randomize_response == 'None' else int(randomize_response)

        base = 'S' + str(section) + 'Q' + str(question_number) + '_' + str(sub_question_label)

        if display_function not in no_resp_tbl_list:
            requires_response_table = True
            if response_table == 'None':
                response_table = str(base) + '_responses'

        if sub_question_label not in list_of_added_sub_questions:
            list_of_added_sub_questions.append(sub_question_label)
            master_string = insert_sub_question(PROJECT, page, sub_question_label, sub_question_text, display_function,
                                                response_table, has_explain, has_other, has_text_year, master_string)

        if requires_response_table:
            if base not in list_of_created_response_tables:
                list_of_created_response_tables.append(base)
                master_string = build_response_table(base, master_string)

            # Fill response table
            if display_function != 'DisplayNothing':
                master_string = fill_sub_question_response_table(base, answer_text, answer_value, has_other,
                                                                 has_explain, has_text_year, randomize_response,
                                                                 master_string)

    return master_string


def fill_sub_question_response_table(base, answer_text, answer_value, has_other, has_explain, has_text_year,
                                     randomize_response, master_string):
    has_other = '0' if has_other == 'None' else int(has_other)
    has_explain = '0' if has_explain == 'None' else int(has_explain)
    has_text_year = '0' if has_text_year == 'None' else int(has_text_year)
    randomize_response = '0' if randomize_response == 'None' else int(randomize_response)
    try:
        answer_value = int(answer_value)
    except Exception as e:
        print('Error: %s', e)
        print('Base: %s', base)

    string = (
        '-- Response Table {0}_responses\n'
        'INSERT INTO {0}_responses (text, value, has_other, has_explain, has_text_year, random, language)\n'
        "VALUES ('{1}', '{2}', '{3}', '{4}', '{5}', '{6}', '1');\n\n"
    ).format(base, answer_text, answer_value, has_other, has_explain, has_text_year, randomize_response)
    master_string = update_master_string(string, master_string)

    return master_string


def build_list_of_test_cases():
    listcase = []

    for i in range(1, 251):
        if len(str(i)) == 1:
            id = 'test00'
        elif len(str(i)) == 2:
            id = 'test0'
        else:
            id = 'test'
        identifier = id + str(i)
        listcase.append(identifier)
    return listcase


def fill_access_table_with_test_cases(PROJECT, master_string):
    list_of_test_cases = build_list_of_test_cases()
    time = datetime.datetime.now()
    batch = time.strftime('%y') + time.strftime('%m') + time.strftime('%d')

    for test_case in list_of_test_cases:
        string = (
            "INSERT INTO {0}.Access (identifier, batch_number)\n"
            "VALUES ('{1}', '{2}');\n"
            "INSERT INTO {0}.Answers (identifier, batch_number)\n"
            "VALUES ('{1}', '{2}');\n\n"
        ).format(PROJECT, test_case, batch)

        master_string = update_master_string(string, master_string)

    return master_string


def prepare_to_build_question(block, master_string, logging, dict, names):
    '''This is for generating all the Answers table column names'''

    for index, row in block.iterrows():
        section = check(row['Section'])
        question_number = check(row['Question_number'])
        sub_question_label = check(row['Subquestion_label'])
        display_function = check(row['Display_function'])

        has_explain = check(row['Has_explain'])
        has_explain = '0' if has_explain == 'None' else int(has_explain)

        has_other = check(row['Has_other'])
        has_other = '0' if has_other == 'None' else int(has_other)

        has_text_year = check(row['Has_text_year'])
        has_text_year = '0' if has_text_year == 'None' else int(has_text_year)

        answer_value = check(row['Answer_value'])

        return_value = build_question(section, question_number, sub_question_label, display_function, answer_value,
                                      has_other, has_text_year, has_explain)
        if type(return_value) == list:
            for item in return_value:
                if item not in names:
                    # logging.debug('return_value: %s', item)
                    names.append(item)
        else:
            if return_value not in names and return_value != 'DisplayNothing':
                # logging.debug('return_value: %s', return_value)
                names.append(return_value)

        if return_value != 'DisplayNothing':
            build_question_disp_func_dict(return_value, display_function, dict)

    # return dict


def build_question(section, qnumber, subQ, display_function, answer_value, has_other, has_textyear, has_explain):
    temp_lst = []
    if answer_value != 'None':
        answer_value = int(answer_value)
    name = 'S' + str(section) + 'Q' + str(qnumber)
    if subQ != 'None':  # Is a subquestion
        name = name + '_' + str(subQ)
        if display_function == 'DisplaySubquestionSubset':
            name = 'S' + str(section) + 'Q' + str(qnumber) + '_' + str(subQ) + '_yr'
            if has_other == 1:
                temp_lst.append(name)
                name = name.replace('_yr', '_other')
                temp_lst.append(name)
                return temp_lst
            else:
                return name
        elif display_function == "DisplayPageCheckboxResponse":
            name = name + '_pcb_' + str(answer_value)
            return name
        elif display_function == "DisplayNothing":
            return 'DisplayNothing'
        else:
            if has_other == 1 or has_explain == 1:
                temp_lst.append(name)
                if has_other == 1:
                    name = name + '_other'
                elif has_explain == 1:
                    name = name + '_explain'
                temp_lst.append(name)
                return temp_lst
            return name
    else:  # Basic Question
        if display_function == 'DisplayCheckboxResponse':
            name = name + '_cb_' + str(answer_value)
            if has_other == 1 or has_explain == 1:
                temp_lst.append(name)
                if has_other == 1:
                    name = name + '_other'
                elif has_explain == 1:
                    name = name + '_explain'
                temp_lst.append(name)
                return temp_lst
            return name
        if has_textyear == 1:
            temp_lst.append(name)
            name = name + '_' + str(answer_value) + '_other_yr'
            temp_lst.append(name)
            return temp_lst
        elif has_other == 1 or has_explain == 1:
            temp_lst.append(name)
            if has_other == 1:
                name = name + '_' + str(answer_value) + '_other'
            elif has_explain == 1:
                name = name + '_' + str(answer_value) + '_explain'
            temp_lst.append(name)
            return temp_lst
    return name


def build_question_disp_func_dict(question, display_function, dict):
    if type(question) == list:
        for q in question:
            if q not in dict:
                dict[q] = display_function
    else:
        if question not in dict:
            dict[question] = display_function
    return dict


def build_answers_table(lst, PROJECT, master_string, dict):
    string = (
        "-- Answers Table\n"
        "DROP TABLE IF EXISTS {0}.Answers;\n"
        "CREATE TABLE {0}.Answers\n"
        "(\n"
        "auto_id INT UNSIGNED AUTO_INCREMENT,\n"
        "identifier VARCHAR(41) NOT NULL DEFAULT 'no-passcode',\n"
        "batch_number MEDIUMINT UNSIGNED NOT NULL DEFAULT 0,\n"
        "last_update TIMESTAMP DEFAULT 0 ON UPDATE CURRENT_TIMESTAMP,\n"
        "L TINYINT UNSIGNED NOT NULL DEFAULT 1,\n"
    ).format(PROJECT)
    for question in lst:
        if question.count('other') > 0 or question[-3:] == '_yr' or dict[question] == 'DisplayTextArea' or dict[
            question] == 'DisplayTextAreaResponse' or dict[question] == 'DisplayTextAreaSmall':
            newstring = question + ' TEXT,\n'
        else:
            newstring = question + ' SMALLINT NOT NULL DEFAULT 9999,\n'
        string = string + newstring
    string = string + (
        'PRIMARY KEY (auto_id),\n'
        'INDEX(identifier)\n'
        ');\n\n'
        '-- Populate Answers table for default user -------------------------------\n\n'
        "INSERT INTO {0}.Answers (identifier) VALUES ('default');\n"
    ).format(PROJECT)
    master_string = update_master_string(string, master_string)
    return master_string


def mandatory_check(block, lst, page):
    for index, row in block.iterrows():
        temp_dict = {}
        mandatory = check(row['Mandatory'])
        section = check(row['Section'])
        question_number = check(row['Question_number'])
        sub_question_label = check(row['Subquestion_label'])

        if sub_question_label != 'None':
            base = 'S' + str(section) + 'Q' + str(question_number) + '_' + str(sub_question_label)
        else:
            base = 'S' + str(section) + 'Q' + str(question_number)

        if mandatory != 'None':
            temp_dict[page] = base
            if temp_dict not in lst:
                lst.append(temp_dict)
    return lst


def build_mandatory_questions_table(lstMandatory, PROJECT, master_string):
    string = (
        '-- -------------------------------------------------------------------------\n\n'
        '-- Mandatory Answers Table\n'
        'DROP TABLE IF EXISTS {0}.MandatoryAnswers;\n'
        'CREATE TABLE {0}.MandatoryAnswers\n'
        '(\n'
        'auto_id SMALLINT NOT NULL AUTO_INCREMENT,\n'
        'page_number SMALLINT,\n'
        'answer VARCHAR(25) NOT NULL,\n'
        'PRIMARY KEY(auto_id)\n'
        ');\n'
        '-- -------------------------------------------------------------------------\n\n'
    ).format(PROJECT)
    for dic in lstMandatory:
        for key, value in dic.items():
            newstring = (
                'INSERT INTO {0}.MandatoryAnswers (page_number, answer)\n'
                "VALUES ('{1}', '{2}');\n\n"
            ).format(PROJECT, key, value)
            string = string + newstring

    master_string = update_master_string(string, master_string)
    return master_string


def build_skips_table(PROJECT, master_string):
    string = (
        'SET NAMES utf8;\n\n'
        '-- use database\n'
        'USE {0};\n'
        'DROP TABLE IF EXISTS Skips;\n\n'
        'CREATE TABLE Skips\n'
        '(\n'
        'skip_from SMALLINT UNSIGNED NOT NULL,\n'
        'because_of TEXT,\n'
        'forward_to SMALLINT UNSIGNED NOT NULL,\n'
        'reason TEXT,\n'
        'PRIMARY KEY(skip_from, forward_to)\n'
        ');\n\n'
    ).format(PROJECT)
    master_string = update_master_string(string, master_string)
    return master_string


def fill_skips_table(block, master_string):
    for index, row in block.iterrows():
        going_into = check(row['going_into'])
        look_at = check(row['look_at'])
        skip_to = check(row['skip_to'])
        conditions = check(row['conditions'])

        string = (
            'INSERT INTO Skips VALUES\n'
            '(\n'
            "'{0}',\n"
            "'{1}',\n"
            "'{2}',\n"
            "'{3}'\n"
            ");\n\n"
        ).format(going_into, look_at, skip_to, conditions)
        master_string = update_master_string(string, master_string)
    return master_string


def build_general_content_table(master_string, PROJECT):
    string = (
        'SET NAMES utf8;\n\n'
        '-- create database\n'
        'CREATE DATABASE IF NOT EXISTS GeneralContent\n'
        'DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;\n\n'
        '-- use database\n'
        'USE GeneralContent;\n'
        'DROP TABLE IF EXISTS {0};\n\n'
        'CREATE TABLE IF NOT EXISTS {0}\n'
        '(\n'
        'survey_title VARCHAR(255) NOT NULL, -- survey id\n'
        'survey_email VARCHAR(255) NOT NULL,\n'
        'language TINYINT UNSIGNED NOT NULL DEFAULT 0,\n'
        'start VARCHAR(20) NOT NULL,\n'
        'login VARCHAR(40) NOT NULL,\n'
        'previous VARCHAR(20) NOT NULL,\n'
        'save VARCHAR(30) NOT NULL,\n'
        'disposition VARCHAR(30) NOT NULL,\n'
        'next VARCHAR(20) NOT NULL,\n'
        'kontinue VARCHAR(20) NOT NULL,\n'
        'finish VARCHAR(20) NOT NULL, \n'
        'survey_logout_text VARCHAR(210) NOT NULL,\n'
        'intro TEXT,\n'
        'intropost TEXT,\n'
        'interviewer TEXT, \n'
        'login_text TEXT,\n'
        'login_error TEXT,\n'
        'survey_complete TEXT, \n'
        'partial_logout TEXT,\n'
        'full_logout TEXT, \n'
        'interviewer_logout TEXT,\n'
        'confidentiality TEXT, \n'
        'instructions TEXT, \n'
        'abbr_guide VARCHAR(40) NOT NULL, \n'
        'page VARCHAR(40) NOT NULL, \n'
        'of VARCHAR(10) NOT NULL, \n'
        'need_answer TEXT,\n'
        'age TEXT,\n'
        'years TEXT,\n'
        'months TEXT,\n'
        'introduction_link TEXT,\n'
        'privacy_link TEXT,\n'
        'instructions_link TEXT,\n'
        'PRIMARY KEY(language)\n'
        ');\n\n'
        'INSERT INTO {0} VALUES\n'
        '(\n'
    ).format(PROJECT)
    master_string = update_master_string(string, master_string)
    return master_string


def fill_general_content(block, master_string):
    temp_string = ''
    for index, row in block.iterrows():
        text = check(row['text'])
        if text == 'None':
            string = "'',\n"
            temp_string = temp_string + string
        elif index + 1 == len(block):  # index + 1 is the lastrow
            string = (
                "'Instructions'\n"
                ");\n"
            )
            temp_string = temp_string + string
        else:
            string = (
                "'{}',\n"
            ).format(text)
            temp_string = temp_string + string
    master_string = update_master_string(temp_string, master_string)
    return master_string


def initial_matrix_setup(master_string):
    string = (
        "-- Matrix Tables ----------------------------------------------------------\n"
        "SET NAMES utf8;\n\n"
        "-- create database \n"
        "CREATE DATABASE IF NOT EXISTS MatrixResponses\n"
        "DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;\n\n"
        "USE MatrixResponses;\n\n"
    )
    master_string = update_master_string(string, master_string)
    return master_string


def process_matrix_tables(block, master_string):
    list_matrix_tables = []
    new = True
    for index, row in block.iterrows():
        table_name = check(row['table_name'])
        label = check(row['label'])
        text = check(row['text'])
        value = check(row['value'])

        if table_name not in list_matrix_tables:
            if len(list_matrix_tables) > 0:
                master_string = matrix_spacing(master_string)
            list_matrix_tables.append(table_name)
            new = True
        else:
            new = False
        master_string = build_matrix_tables(new, table_name, label, text, value, master_string)
    return master_string


def build_matrix_tables(new, table_name, label, text, value, master_string):
    if new:
        string = (
            "DROP TABLE IF EXISTS {0};\n"
            "CREATE TABLE {0}\n"
            "(\n"
            "sortindex TINYINT(3) UNSIGNED NOT NULL AUTO_INCREMENT,\n"
            "language TINYINT(3) UNSIGNED NOT NULL DEFAULT '1',\n"
            "label VARCHAR(63) NOT NULL,\n"
            "text VARCHAR(42) NOT NULL,\n"
            "value TINYINT(3) UNSIGNED NOT NULL DEFAULT '99',\n"
            "PRIMARY KEY (sortindex, language, text)\n"
            ");\n"
        ).format(table_name)
        master_string = update_master_string(string, master_string)
    string = (
        "INSERT INTO MatrixResponses.{0} (label, text, value) VALUES ('{1}', '{2}', '{3}');\n"
    ).format(table_name, label, text, value)
    master_string = update_master_string(string, master_string)
    return master_string


def matrix_spacing(master_string):
    string = (
        '\n'
        "-- -------------------------------------------------------------------------\n"
        "-- -------------------------------------------------------------------------\n\n"
    )
    master_string = update_master_string(string, master_string)
    return master_string


def build_disposition_log_table(PROJECT, master_string):
    string = (
        "SET NAMES utf8;\n\n"
        "-- use database\n"
        "USE {0};\n"
        "-- -------------------------------------------------------------------------\n\n"
        "-- disposition_log table\n"
        "DROP TABLE IF EXISTS disposition_log;\n\n"
        "CREATE TABLE disposition_log\n"
        "(\n"
        "interviewer_id VARCHAR(41) NOT NULL DEFAULT 'no-passcode',  -- user passcode\n"
        "case_id VARCHAR(41) NOT NULL DEFAULT 'no-passcode',   -- user passcode\n\n"
        "-- updated last\n"
        "last_called TIMESTAMP DEFAULT NOW(),\n"
        "L TINYINT UNSIGNED NOT NULL DEFAULT 1,\n\n"
        "SIQdisp1_a SMALLINT UNSIGNED NOT NULL DEFAULT 9999,\n"
        "SIQdisp1_b TEXT,\n\n"
        "PRIMARY KEY(case_id, last_called)\n"
        ");\n"
        "-- -------------------------------------------------------------------------\n\n"
    ).format(PROJECT)
    master_string = update_master_string(string, master_string)
    return master_string


def build_grant_statements(PROJECT, master_string, SURVEY_TYPE):
    if SURVEY_TYPE == 'CATI':
        string = (
            "-- GRANT Statments\n\n"
            "INSERT INTO disposition_log(interviewer_id) VALUES(default);\n"
            "GRANT SELECT ON disposition_log TO 'SampleUser'@'%';\n"
            "GRANT SELECT, INSERT ON disposition_log TO '{0}_work'@'localhost' IDENTIFIED BY 's@mpl3_p@ss';\n"
            "GRANT SELECT ON dispositions.* TO '{0}_work'@'localhost' IDENTIFIED BY 's@mpl3_p@ss';\n\n"
        ).format(PROJECT)
        master_string = update_master_string(string, master_string)
        master_string = fill_grants_CATI(PROJECT, master_string)
    else:
        master_string = fill_grants_WEB(PROJECT, master_string)
    return master_string


def fill_grants_WEB(PROJECT, master_string):
    user = "'SampleUser'@'%'"
    user1 = "'user1'@'localhost'"
    user2 = "'heimdal'@'localhost'"
    work_account = "'{}_work'@'localhost' IDENTIFIED BY 's@mpl3_p@ss'".format(PROJECT)

    string = (
        "\n"
        "-- -------------------------------------------------------------------------\n"
        "-- Granting the survey proper rights\n\n"
        "GRANT SELECT ON {0}.*\n"
        "TO {1};\n\n"
        "GRANT SELECT ON {0}.Access\n"
        "TO {2};\n\n"
        "GRANT UPDATE (identifier, saved, status) on {0}.Access\n"
        "TO {2};\n\n"
        "GRANT SELECT ON {0}.Answers\n"
        "TO {2};\n\n"
        "GRANT SELECT, UPDATE ON {0}.Access\n"
        "TO {3};\n\n"
        "GRANT SELECT, UPDATE ON {0}.Answers\n"
        "TO {3};\n\n"
        "GRANT SELECT, UPDATE ON {0}.Access\n"
        "TO {4};\n\n"
        "GRANT SELECT, UPDATE ON {0}.Answers\n"
        "TO {4};\n\n"
        "GRANT SELECT, UPDATE ON GeneralContent.{0}\n"
        "TO {3};\n\n"
        "GRANT SELECT, UPDATE ON GeneralContent.{0}\n"
        "TO {4};\n\n"
        "GRANT UPDATE ON {0}.Answers\n"
        "TO {1};\n\n"
        "GRANT UPDATE (pw_assigned, saved, status) ON {0}.Access\n"
        "TO {1};\n\n"
        "GRANT INSERT, DELETE ON {0}.Stack\n"
        "TO {1};\n\n"
        "GRANT INSERT, UPDATE ON {0}.Pipeline\n"
        "TO {1};\n\n"
        "GRANT SELECT ON MatrixResponses.*\n"
        "TO {1};\n\n"
        "GRANT SELECT ON GeneralContent.{0}\n"
        "TO {1};\n\n"
    ).format(PROJECT, work_account, user, user1, user2)
    master_string = update_master_string(string, master_string)
    return master_string


def fill_grants_CATI(PROJECT, master_string):
    user = "'SampleUser'@'%'"
    user1 = "'user1'@'localhost'"
    user2 = "'user2'@'localhost'"
    work_account = "'{}_work'@'localhost' IDENTIFIED BY 's@mpl3_p@ss'".format(PROJECT)

    string = (
        "\n"
        "-- -------------------------------------------------------------------------\n"
        "-- Granting the survey proper rights\n\n"
        "GRANT SELECT ON {0}.*\n"
        "TO {1};\n\n"
        "GRANT SELECT ON {0}.Access\n"
        "TO {2};\n\n"
        "GRANT UPDATE (identifier, saved, status) on {0}.Access\n"
        "TO {2};\n\n"
        "GRANT SELECT ON {0}.Answers\n"
        "TO {2};\n\n"
        "GRANT SELECT, UPDATE ON {0}.Access\n"
        "TO {3};\n\n"
        "GRANT SELECT, UPDATE ON {0}.Answers\n"
        "TO {3};\n\n"
        "GRANT SELECT, UPDATE ON {0}.Access\n"
        "TO {4};\n\n"
        "GRANT SELECT, UPDATE ON {0}.Answers\n"
        "TO {4};\n\n"
        "GRANT SELECT, UPDATE ON GeneralContent.{0}\n"
        "TO {3};\n\n"
        "GRANT SELECT, UPDATE ON GeneralContent.{0}\n"
        "TO {4};\n\n"
        "GRANT UPDATE ON {0}.Answers\n"
        "TO {1};\n\n"
        "GRANT UPDATE (pw_assigned, saved, status) ON {0}.Access\n"
        "TO {1};\n\n"
        "GRANT INSERT, DELETE ON {0}.Stack\n"
        "TO {1};\n\n"
        "GRANT INSERT, UPDATE ON {0}.Pipeline\n"
        "TO {1};\n\n"
        "GRANT SELECT ON dispositions.*\n"
        "TO {1};\n\n"
        "GRANT INSERT ON {0}.disposition_log\n"
        "TO {1};\n\n"
        "GRANT SELECT ON MatrixResponses.*\n"
        "TO {1};\n\n"
        "GRANT SELECT ON GeneralContent.{0}\n"
        "TO {1};\n\n"
    ).format(PROJECT, work_account, user, user1, user2)
    master_string = update_master_string(string, master_string)
    return master_string