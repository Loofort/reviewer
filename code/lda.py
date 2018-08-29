from gensim import corpora, models, similarities, utils
import logging
import os
import string
import pyLDAvis.gensim as gensimvis
import pyLDAvis
import datetime

input = 'data.jeans.txt'
logging.basicConfig(format='%(asctime)s : %(levelname)s : %(message)s', level=logging.INFO)

dictionary = corpora.Dictionary(line.split() for line in open(input))

class MyCorpus(object):
    def __iter__(self):
        for line in open(input):
            # assume there's one document per line, tokens separated by whitespace
            yield dictionary.doc2bow(line.split())



#mycorpus = MyCorpus()
mycorpus = [dictionary.doc2bow(line.split()) for line in open(input)]

from gensim.models.callbacks import PerplexityMetric
import visdom
vis = visdom.Visdom()
#perplexity_logger = PerplexityMetric(corpus=mycorpus, logger='shell')
#perplexity_logger = PerplexityMetric(corpus=mycorpus, logger='visdom', viz_env=vis, title="visTitle")
perplexity_logger = PerplexityMetric(corpus=mycorpus, logger='visdom')


model = models.LdaModel(corpus=mycorpus, id2word=dictionary, num_topics=25, passes=100, distributed=False, callbacks=[perplexity_logger])
#model.save('lda.model')

print("LEN: {}".format(len(mycorpus)))
print(datetime.datetime.now())
vis_data = gensimvis.prepare(model, mycorpus, dictionary)
#pyLDAvis.display(vis_data)
pyLDAvis.save_html(vis_data, 'lda.html')




