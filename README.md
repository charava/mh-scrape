Hey Wes! For my web-scraping-with-Ruby exploration, I tried scraping local mental health service directories. For tangential background on this exploration: I chose this topic because I'm currently doing a research project for my Economics Thesis Seminar class on the CA psychiatric bed shortage, so I thought it would be useful to focus my scraping pursuits on gathering some relevant data. I'm also interested in compiling a [more easily searchable directory of mental health services for our local Bay Area community](https://github.com/charava/nami_resources) given that [this government site](http://cdn.smchealth.org/directory.html) and the many other sites like that on the web today could use some more...love? maybe a bit of a glow-up? Anyway, I'm very excited to continue along this data-y adventure and explore what's to come in Data Science! Thanks for taking the time to read this :)

### The URL(s) where the original data was located:
[SMC Health Directory](https://smchealthonline.com/directory/index.php?ID=&site_city=&site_zip=&languages=&site_specialty=&search=y)

### My scraping code:
[smc_mh_scrape.rb](smc_mh_scrape.rb) and its initial output: [scrape_output.csv](scrape_output.csv)

 _I also tried scraping another [SMC website](http://cdn.smchealth.org/directory.html) but ran into some issues, so you can see my _failed_ scrape attempt in [FAILED_smc_site2_scrape.rb](FAILED_smc_site2_scrape.rb)._

 ### Cleaning the data code 
 [post_scrape_cleanup.ipynb](post_scrape_cleanup.ipynb) 
 
 _I tried my best to use Ruby to do a lot of this data cleaning but it got really painful so I moved to Python for my sanity😭_


### A csv file with the data:
[FINALDATA_smc_scraped.csv](FINALDATA_smc_scraped.csv)


