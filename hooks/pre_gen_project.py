import re
import sys

project_name = '{{ cookiecutter.project_name }}'
if not re.match(r'^[a-zA-Z][\-_a-zA-Z0-9]+$', project_name):
    print(f"ERROR: invalid project name '{project_name}'. Must start with a letter followed by letter, digits, underscores or dashes")
    sys.exit(1)

billing_account = '{{ cookiecutter.billing_account }}'
if not re.match(r'^[A-F0-9\-]{20}$', billing_account):
    print(f"ERROR: invalid billing account '{billing_account}'. expected all hexadecimal digits separated by dashes")
    sys.exit(1)

project_owner = '{{ cookiecutter.project_owner }}'
if not re.match(r"(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)", project_owner):
    print(f"ERROR: invalid project owner '{project_owner}'. expected email address")
    sys.exit(1)
