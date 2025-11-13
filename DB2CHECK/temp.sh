mvn dependency:get -Dartifact=com.ibm:db2jcc4:4 > /dev/null 2>&1
        if [ $? != 0 ];
        then
        
            echo "installing db2 jars in repository for Run Control Apps"
            mvn install:install-file -Dfile=$GERS_JARS/db2jcc4.jar -DgroupId=com.ibm -DartifactId=db2jcc4 -Dversion=4 -Dpackaging=jar
            mvn install:install-file -Dfile=$GERS_JARS/db2jcc_license_cu.jar -DgroupId=com.ibm -DartifactId=db2jcc_license_cu -Dversion=4 -Dpackaging=jar
            mvn install:install-file -Dfile=$GERS_JARS/db2jcc_license_cisuz.jar -DgroupId=com.ibm -DartifactId=db2jcc_license_cisuz -Dversion=4 -Dpackaging=jar
        else
            echo "Jars for db2 in maven repository for Run Control Apps"
        fi
