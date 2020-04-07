import re
import sys
import subprocess

project_name = "{{ cookiecutter.project_name }}"
if not re.match(r"^[a-zA-Z][\-_a-zA-Z0-9]+$", project_name):
    print(
        f"ERROR: invalid project name '{project_name}'. Must start with a letter followed by letter, digits, underscores or dashes"
    )
    sys.exit(1)

billing_account = "{{ cookiecutter.billing_account }}"
if not re.match(r"^[A-F0-9\-]{20}$", billing_account):
    print(
        f"ERROR: invalid billing account '{billing_account}'. expected all hexadecimal digits separated by dashes"
    )
    sys.exit(1)

project_owner = "{{ cookiecutter.project_owner }}"
if not re.match(r"(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)", project_owner):
    print(f"ERROR: invalid project owner '{project_owner}'. expected email address")
    sys.exit(1)

process = subprocess.Popen(
    ["gcloud", "config", "get-value", "account"],
    cwd=".",
    stdout=subprocess.PIPE,
    stderr=subprocess.PIPE,
    universal_newlines=True,
)
out = process.communicate()
if process.returncode != 0:
    print(
        f"ERROR:failed to execute 'gcloud config get-value account', {(out[0]+out[1])}"
    )
    exit(1)

account_id = out[0].strip("\n")
if project_owner != account_id:
    print(
        f"ERROR: please configure gcloud to use th account '{project_owner}',\n\tcurrently it is set to '{account_id}'"
    )
    sys.exit(1)
