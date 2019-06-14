import os

PROJECT = 'sample'
WEBSHEET_FILENAME = "sample_websheet.xlsx"

file_directory = os.path.dirname(os.path.abspath(__file__))
PROJECT_DIRECTORY = os.path.dirname(file_directory)
WEBSHEET_DIR = os.path.join(PROJECT_DIRECTORY, "websheet")
WEBSHEET_PATH = os.path.join(WEBSHEET_DIR, WEBSHEET_FILENAME)

output_directory = os.path.join(PROJECT_DIRECTORY, 'output')

outfile = PROJECT + '.sql'
outfile_path = os.path.join(output_directory, outfile)



SURVEY_TYPE = 'WEBSRG'  # PUT IN CAPS



added_sections_list = []

# Used in both sub questions and questions
disp_functions_with_no_resp_table = ['DisplayMatrixResponse', 'DisplayTextAreaResponse',
                                     'DisplaySubquestionSubset', 'DisplayNothing', 'DisplayTextArea',
                                     'DisplayTextAreaSmall']

# used in def build_insert_questions
# display functions in this list need to be included as the 'responses' field when you
# insert into project.Questions
simple_display_functions_to_include_in_insert_questions = ['DisplayMatrixResponse', 'DisplayTextAreaSmall',
                       'DisplayPageCheckboxResponse', 'DisplayNothing',
                       'DisplaySubquestionSubset']

multi_display_functions_to_include_in_insert_questions = ['DisplayMatrixResponse', 'DisplayTextAreaSmall',
                       'DisplayPageCheckboxResponse', 'DisplayNothing',
                       'DisplaySubquestionSubset', 'DisplayRadioResponse']



# used for both sub questions and regular questions
# list of mandatory questions, added to when each block is processed
# used after all blocks have been processed to build mandatory table
mandatory_list = []


# used for single questions only
# for Insert New Single Question, if the display function is in this list
# that means there is no response table.  If the display function is not in this list
# that means that the response table is base + _responses (e.g. SIQ1_responses)
disp_functions_for_insert_single_question = ['DisplayYears40', 'DisplayTextArea', 'DisplayTextAreaResponse']

# holds the values of the Answers table names that have already been found
names = []

# used in generating the Answers table fields. Holds column names (SIQ1_a) as keys and their
# display functions as values
dict_question_display_function = {}

