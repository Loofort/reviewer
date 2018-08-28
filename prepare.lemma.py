from nltk.corpus import stopwords 
from nltk.stem.wordnet import WordNetLemmatizer
import string

stop = set(stopwords.words('english'))
exclude = set(string.punctuation) 
lemma = WordNetLemmatizer()
def clean(doc):
    stop_free = " ".join([i for i in doc.lower().split() if i not in stop])
    punc_free = ''.join(ch for ch in stop_free if ch not in exclude)
    return punc_free
    #normalized = " ".join(lemma.lemmatize(word) for word in punc_free.split())
    #return normalized



#######################################################################################33
import fileinput
for line in fileinput.input():
    result = clean(line)
    if len(result) > 0 :
        print(result)


