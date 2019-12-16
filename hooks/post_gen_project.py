from os import path
import sys
import subprocess


def exec_git(directory, cmd):
    process = subprocess.Popen(
        cmd,
        cwd=directory,
        stdout=sys.stdout,
        stderr=sys.stderr,
        universal_newlines=True,
    )
    out = process.communicate()
    if process.returncode != 0:
        sys.exit(1)


for repo in ["cicd", "infrastructure"]:
    project = "{{cookiecutter.project_name}}"
    dir = path.join(".", repo)
    exec_git(dir, ["git", "init"])
    exec_git(dir, ["git", "add", "."])
    exec_git(dir, ["git", "commit", "-m", "initial import"])
    exec_git(
        dir,
        [
            "git",
            "remote",
            "add",
            "origin",
            f"https://source.developers.google.com/p/{project}-cicd/r/{repo}",
        ],
    )
