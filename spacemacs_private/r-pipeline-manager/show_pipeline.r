### show_pipeline.r --- This script scans the pipeline script files and generate a flowchart
generate_flowchart = function() {
  ##TODO: require diagram package in readme
  if(!require(diagram)) stop('error loading diagram package, try install.packages(diagram)\n')
  ##TODO: this fxn works only if the current dir is the pipeline containing dir
  scripts=list.files(path='.',pattern='^[a-z]\\.[0-9]\\..*\\.r$')
  ##get the input and result for each script, establish the relationship 
  script_relation = c()
  for(file in scripts) {
    cat(file,'\n')
    ##TODO:what if those files are very long..?
    file_content = readLines(file)
    idx = grepl('^#\'',file_content)
      metainfo = file_content[idx]
    ##trimws only trim heading and tailing white-space characters by default
    metainfo = trimws(metainfo)
    gsub('^#\'','',metainfo) -> metainfo
      metainfo <- trimws(metainfo)
    gsub('^@','',metainfo) -> metainfo
    ##split uses regexp, this one is better
    strsplit(metainfo, split = ':\\s+' ) -> input_output
    names(input_output) = unlist(lapply(input_output,function(e) e[1]))
    input_output = lapply(input_output,function(e) unlist(strsplit(e[-1],split='\\s+')))

    if(all(is.null(unlist(input_output)))) {
      ##in case you run this fxn while some scripts are just created and without input and output parameters set
      cat('empty file\n')
      next
    }

    input_outputi = as.matrix(cbind(script=file, input=input_output$input, output=input_output$output))
    script_relation = rbind(script_relation,input_outputi)
  }
  as.matrix(merge(x=script_relation,y= script_relation, by.x = 'output',by.y='input')) -> script_relation1

  coef_matrix=matrix(0,ncol=length(scripts),nrow=length(scripts))
  rownames(coef_matrix)=colnames(coef_matrix) = scripts
  coef_matrix[ script_relation1[,c('script.x','script.y')] ] = script_relation1[ ,1]
  tmp = unlist(lapply(strsplit(scripts, split = '\\.'),function(e) e[1]))
  names(tmp) = scripts
  pos = table(tmp)
  if(file.exists('pipeline-diagram.png')) file.remove('pipeline-diagram.png')
  png('pipeline-diagram.png',width = 800,height = 800)
  par(mar=c(1,1,1,1))
  plotmat(t(coef_matrix),
          ## pos = pos,
          curve = 0, name = scripts, lwd = 1, box.lwd = 1,
          cex.txt = .6,box.type = 'ellipse', box.prop = 0.4,shadow.size=0,
          ##          dtext=-0.2,
          arr.col='white',
          ##          arr.lcol='grey60',
          arr.type='triangle')
  dev.off()
  ## save(script_relation,script_relation1,coef_matrix,pos,file='relation.rda')
}

##run this script at working directory
generate_flowchart()
