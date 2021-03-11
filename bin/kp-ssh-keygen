#!/usr/bin/env python3
from pykeepass import PyKeePass, create_database
import uuid
import subprocess
import os
import argparse

def generate_passphrase(length=60):
    return subprocess.check_output(["pwgen", "--secure", "--numerals", "--symbols", str(length), "1"]).decode()

def attach(kp, entry, name, text, encoding="utf-8"):
    txt = kp.add_binary(text.encode(encoding))
    return entry.add_attachment(txt, name)

def generate_keys(password):
    # Random id
    keyname = uuid.uuid4()

    # Path names
    pub_path, priv_path = f"/tmp/{keyname}.pub", f"/tmp/{keyname}"

    # Generate keys
    subprocess.check_output(["ssh-keygen", "-b", "4096", "-f", priv_path, "-N", password])

    # Read key contents
    pub = open(pub_path, "r").read()
    priv = open(priv_path, "r").read()

    # Remove the generated files
    os.remove(pub_path), os.remove(priv_path)

    return pub, priv

def keepassxc_new_ssh_key(db_name, db_password, passphrase="", title="", username=""):
    kp = PyKeePass(db_name, password=db_password)

    keyname = title.replace(" ", "-")

    ssh_group = kp.find_groups(name="SSH", first=True)
    if not ssh_group:
        ssh_group = kp.add_group(kp.root_group, "SSH")
        

    entry = kp.add_entry(ssh_group, title=title, username=username, password=passphrase)

    pub, priv = generate_keys(passphrase)

    entry_ssh_settings = f"""\
<?xml version="1.0" encoding="UTF-16"?>
<EntrySettings xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <AllowUseOfSshKey>true</AllowUseOfSshKey>
  <AddAtDatabaseOpen>true</AddAtDatabaseOpen>
  <RemoveAtDatabaseClose>true</RemoveAtDatabaseClose>
  <UseConfirmConstraintWhenAdding>false</UseConfirmConstraintWhenAdding>
  <UseLifetimeConstraintWhenAdding>true</UseLifetimeConstraintWhenAdding>
  <LifetimeConstraintDuration>600</LifetimeConstraintDuration>
  <Location>
    <SelectedType>attachment</SelectedType>
    <AttachmentName>{keyname}</AttachmentName>
    <SaveAttachmentToTempFile>false</SaveAttachmentToTempFile>
  </Location>
</EntrySettings>"""

    attach(kp, entry, "KeeAgent.settings", entry_ssh_settings, encoding="utf-16")

    attach(kp, entry, keyname, priv)
    attach(kp, entry, f"{keyname}.pub", pub)

    kp.save()

def cli():
    parser = argparse.ArgumentParser()
   
    parser.add_argument('-d', '--db', help="database path", default=os.environ.get('KP_SSH_DB'))

    parser.add_argument('-s', '--db-password', help="database password", default=os.environ.get('KP_SSH_DB_PASSWORD'))


    parser.add_argument('-p', '--passphrase', help="ssh key password", default=generate_passphrase())

    parser.add_argument('-t', '--title', help="entry title", required=True)

    parser.add_argument('-c', '--comment', help="ssh public key comment", required=True)

    return parser

if __name__ == "__main__":
    args = cli().parse_args()

    keepassxc_new_ssh_key(args.db, args.db_password, passphrase=args.passphrase, title=args.title)
