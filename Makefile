HUNTDIR=/home/mihaltz/hun-tools
export PYTHONPATH = /home/eszter/liblinear-1.91/python

# Place your input .txt files here. All output files will also be put here.
OUTDIR=./work

# No. of parallel jobs to run
NCORES=1
# Name of file with numbe of parallel jobs to run. May be modified while parallel is running, so num. of running jobs can be changed
#PROCFILE=./.ncores


.PHONY: allnlp tokenize posmorph stem stem1 ner

all: tokenize posmorph stem stem1

# do all NLP steps on plain text files, do after dbget
#allnlp: tokenize posmorph stem stem1 ner
#allnlp: tokenize posmorph stem stem1 ner


# call huntoken (+ special tricks) to tokenize: *.txt => *.tok
tokenize:
#	ls $(OUTDIR)/*.txt | parallel -j $(NCORES) --progress "echo {}; ./mytokenize.py {} {.}.tok"
#	ls $(OUTDIR)/*.txt | parallel -j $(NCORES) --progress "echo {}; ./mytokenize.py.noadapt {} {.}.tok"
	ls $(OUTDIR)/*.txt | parallel -j $(NCORES) --progress "echo {}; ./010.huntoken < {} > {.}.tok"


# call hunpos + ocamorph on tokenized files 
# Do it in parallel processes to utilize all available CPU cores (but keep 1 core idle for other users :)
posmorph:
	ls $(OUTDIR)/*.tok | parallel -j $(NCORES) --progress "echo {}; $(HUNTDIR)/011.hunpos-hunmorph < {} > {.}.posmorph"

# Do stemming and morphana selection
# Use parallel
stem:
	ls $(OUTDIR)/*.posmorph | parallel -k -j $(NCORES) "echo {}; $(HUNTDIR)/012.stem -m --oovstr 'OOV' --morphdel '||' {} {.}.stem"

# Using .stem files disambiguate anas, improve lemmas
# Note: huntoken introduces some double blank lines, suppress these (cat -s) since they crash huntag (next step)
# TODO: merge this into stem
stem1:
	ls $(OUTDIR)/*.stem | parallel -k -j $(NCORES) "echo {}; ./013.chooseana.py {} | cat -s > {.}.stem1"

# Run NER on *.stem1 files, save into *.stem1.ner
# This uses NER code in /home/eszter/HunTag
ner:
	ls $(OUTDIR)/*.stem1 | parallel -j-2 "iconv -f UTF-8 -t CP1250//TRANSLIT < {} | python /home/eszter/HunTag/huntag.py tag -m /home/eszter/HunTag/models/ner.maven7 -b /home/eszter/HunTag/models/szeged.ner.all.bigram -c /home/eszter/HunTag/configs/hunner_maven7.cfg > {}.ner.CP1250 ; grep -v '^Accuracy = ' {}.ner.CP1250 | iconv -f CP1250 -t UTF-8 > {}.ner ; rm {}.ner.CP1250"


