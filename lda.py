from gensim import corpora, models, similarities, utils
import logging
import os
import string
import pyLDAvis.gensim as gensimvis
import pyLDAvis

input = 'data.jeans.txt'
#logging.basicConfig(format='%(asctime)s : %(levelname)s : %(message)s', level=logging.INFO)

dictionary = corpora.Dictionary(line.split() for line in open(input))

class MyCorpus(object):
    def __iter__(self):
        for line in open(input):
            # assume there's one document per line, tokens separated by whitespace
            yield dictionary.doc2bow(line.split())



#mycorpus = MyCorpus()
mycorpus = [dictionary.doc2bow(line.split()) for line in open(input)]

model = models.LdaModel(corpus=mycorpus, id2word=dictionary, num_topics=50, passes=100, distributed=False)
#model.save('lda.model')

print("LEN: {}".format(len(mycorpus)))
vis_data = gensimvis.prepare(model, mycorpus, dictionary)
#pyLDAvis.display(vis_data)
pyLDAvis.save_html(vis_data, 'lda.html')




