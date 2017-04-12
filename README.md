# hunlp-scripts

Hungarian NLP pipeline for tokenization and sentence detection using `huntoken`, PoS-tagging using `hunpos`, morphological analysis using `hunmorph`, stem generation and 
heuristic stem seletion based on the PoS-tag with python scripts.

Created by Marton Mihaltz 

## Installation

1. clone this repo:  
`https://github.com/mmihaltz/hunlp-pipeline.git`

2. Run `setup.sh` to install python requirements (may require `sudo` depending on your setup)

3. Obtain the hunlp tools:  
- huntoken
- hunpos
- hunmorph

4. In `010.huntoken`, `011.hunmorph`, `011.hunpos-hunmorph` set the HUNTDIR variable to the directory that contains the tools in 3.

## Usage

See `Makefile`.
