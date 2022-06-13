def getImageListMethod(String BuildType, String FromEnv, String CurrentEnv, String APIName){
try{
  GroovyShell shell = new GroovyShell()
  commonMethodsScript = shell.parse(new File('/var/lib/jenkins/commonMethod.groovy'))
  List<String>groups = new ArrayList<String>()
  getGroupsCommand = ''

 if (BuildType.equals("Tag Only") || BuildType.equals("Tag & Deploy")) {
    getGroupsCommand = 'source /var/lib/jenkins/.bashrc && export PATH=\'/var/lib/jenkins/google-cloud-sdk/bin:/usr/lib64/qt-3.3/bin:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/var/lib/jenkins/bin\' && gcloud container images list-tags us.gcr.io/just-slate-88918/' + APIName + ' --sort-by=\"~TIMESTAMP\" | grep ' + FromEnv + ' | awk \'{print $2}\''
  }
  else{
    getGroupsCommand = 'source /var/lib/jenkins/.bashrc && export PATH=\'/var/lib/jenkins/google-cloud-sdk/bin:/usr/lib64/qt-3.3/bin:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/var/lib/jenkins/bin\' && gcloud container images list-tags us.gcr.io/just-slate-88918/' + APIName + ' --sort-by=\"~TIMESTAMP\" | grep ' + CurrentEnv + ' | awk \'{print $2}\''
  }

  //return getGroupsCommand

List<String> outputs = commonMethodsScript.runCommand(getGroupsCommand)
    String[] lines= outputs.get(0).toString().split("\\n")
    for (String item : lines) {
          def result = ''
          if(!BuildType.equals("Deploy Only") && !item.contains(CurrentEnv)){
              result = item.split(",").find { tagName -> tagName.contains(FromEnv)}
              println "$result"
              groups.add(result)
           }
           if(BuildType.equals("Deploy Only")){
               result = item.split(",").find { tagName -> tagName.contains(CurrentEnv)}
               println "$result"
               groups.add(result)
            }
    }
    return groups
}
catch(IOException ex){
   print "IOException!!! The commonMethods.groovy file doesn't exist!!!\n"
}
}

