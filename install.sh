#!/bin/bash
export VIRTUALENV='someenv'
rm -fr $VIRTUALENV
python3 -m virtualenv $VIRTUALENV
source $VIRTUALENV/bin/activate
source requeriments_install.sh
deactivate

#!/bin/bash