#!/bin/bash


if [ ! -z $1 ]; then
    echo "Compiling $1"
    # Let's first create the tex file for the specified document
    # Check to see if the filename ends with beamer.md which will indicate
    # pandoc should output beamer slides
    if [[ $filename == *"beamer.md" ]]; then
        pandoc --to=beamer -s -o $(basename ${1//_/-} beamer.md)slides.tex $1
    else
        pandoc -s -o $(basename ${1//_/-} .md).tex $1
    fi
else
    echo "No document was specified -- Compiling all markdown files"

    for filename in *.md; do
        # Skip compiling the README file
        if [ $filename == "README.md" ]
        then
            continue
        fi

        if [[ $filename == *"beamer.md" ]]; then
            pandoc --to=beamer -s -o $(basename ${filename//_/-} beamer.md)slides.tex $filename
        else
            pandoc -s -o $(basename ${filename//_/-} .md).tex $filename
        fi
    done
fi


# Let's now compile each tex file 2 times to get the toc working correctly
for filename in *.tex; do
    for ((i=1; i<=2; i++)); do
        pdflatex -shell-escape $filename
    done
done


# Clean up minted and log files if they exist
echo -e "\n\nCleaning up the following files:\n"

ls -1 | grep '^_minted'
ls -1 | grep '.tex$'
ls -1 | grep '.aux$'
ls -1 | grep '.log$'
ls -1 | grep '.out$'
ls -1 | grep '.toc$'
ls -1 | grep '.nav$'
ls -1 | grep -q '.snm$'
ls -1 | grep -q '.vrb$'

echo ""

read -r -p "Proceed? [y/N] " response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    if ls -1 | grep -q '^_minted'; then
        rm -r _minted*
    fi
    if ls -1 | grep -q '.tex$'; then
        rm *.tex
    fi
    if ls -1 | grep -q '.aux$'; then
        rm *.aux
    fi
    if ls -1 | grep -q '.log$'; then
        rm *.log
    fi
    if ls -1 | grep -q '.out$'; then
        rm *.out
    fi
    if ls -1 | grep -q '.toc$'; then
        rm *.toc
    fi
    if ls -1 | grep -q '.nav$'; then
        rm *.nav
    fi
    if ls -1 | grep -q '.snm$'; then
        rm *.snm
    fi
    if ls -1 | grep -q '.vrb$'; then
        rm *.vrb
    fi
fi
