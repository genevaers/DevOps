mvn dependency:get -Dartifact=com.ibm:db2jcc4:4 > /dev/null 2>&1
        if [ $? != 0 ];
        then
        
            echo "installing db2 jars in repository for Run Control Apps"
            mvn install:install-file -Dfile="C/Users/NeilBeesley/git/public/Workbench/database/db2/Java/db2jcc4.jar" -DgroupId=com.ibm.db2 -DartifactId=db2jcc4 -Dversion=4 -Dpackaging=jar
            echo "Jars for db2 in maven repository for Run Control Apps"
        fi
