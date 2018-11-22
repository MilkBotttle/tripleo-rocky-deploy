#!/usr/bin/python

DOCUMENTATION = '''
---
module: docker_save
short_description: Save docker image to tar
description:
    - Save docker image to tar
options:
  dest:
    description:
      - The description file name
    retuired: True
    type: str
  name:
    description: target docker image name

