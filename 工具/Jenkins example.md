# example
```groovy
def generateBuildInfo(){
    return new Date().format('yyyyMMdd_HHmm') + "_build${BUILD_NUMBER}"
}
def getResourcePram(String temp_context){
    echo "temp_context is ${temp_context}"
    env.CASE_LIST=temp_context
    
}

import static java.util.Calendar.DAY_OF_WEEK;

pipeline {
    agent { label 'spsd_cd_auto_test_16' }
    options {
        timestamps()
        lock(label: "linklayer_evb_board", quantity: 9, variable: "resource_name")
    }
    environment {
        testlink_db_password=credentials('testlink_db_password')
        testlink_api_devkey=credentials('Testlink_API_Devkey')
        testlink_api_test_devkey=credentials('Testlink_API_Test_Devkey')
        BUILD_INFO = generateBuildInfo()
        // CASE_LIST = ""
        JSON_FILE = "api_test_status.json"
        OPT_BACKUP_NODE = "192.168.103.231"
        OPT_BACKUP_USERNAME = "cn1573"
    }
    stages {

        // stage('CleanWorkspace'){
        //     steps{
        //         // cleanWs()
        //         echo "eeeeeee"
        //     }
        // }
        // stage('Get last successful build ') {
        //     steps {
        //         script {
        //             if (env.RELEASE_BUILD_PATH_URL.isEmpty()){
        //                 echo "lastSuccessfulBuild.getEnvironment"
        //                 def board_test_job = Jenkins.instance.getItem("pulsar_ble")
        //                 def environment_map = board_test_job.lastSuccessfulBuild.getEnvironment()
        //                 for (Map.Entry<String, String> entry : environment_map.entrySet()) {
        //                     env.key = entry.getKey()
        //                     env.value = entry.getValue()
        //                     echo "env.key is ${key}, value is ${value}"
        //                     if (entry.getKey() == "BUILD_INFO"){
        //                         env.RELEASE_BUILD_PATH_URL = "http://jenkins-spsd.verisilicon.com/image/osprey/" + entry.getValue() + "/image/"
        //                         echo "RELEASE_BUILD_PATH_URL is ${RELEASE_BUILD_PATH_URL}"
        //                     }else if (entry.getKey() == "JENKINS_BUILD_VERSION"){
        //                         env.GALAXY_JENKINS_BUILD_VERSION = entry.getValue()
        //                         echo "GALAXY_JENKINS_BUILD_VERSION is ${GALAXY_JENKINS_BUILD_VERSION}"
        //                     }else if (entry.getKey() == "BUILD_URL"){
        //                         env.TARGET_BUILD_URL = entry.getValue()
        //                         echo "TARGET_BUILD_URL is ${TARGET_BUILD_URL}"
        //                     }
        //                 }
        //             }
        //             else{
        //                 echo "RELEASE_BUILD_PATH_URL is ${env.RELEASE_BUILD_PATH_URL}"
        //                 echo "GALAXY_JENKINS_BUILD_VERSION is ${env.GALAXY_JENKINS_BUILD_VERSION}"
        //                 echo "TARGET_BUILD_URL is ${env.TARGET_BUILD_URL}"
        //             }


        //             def now = new Date()
        //             String now_str = now.format("yyyyMMdd_HHmm")
        //             now_str += "_build" + String.valueOf(currentBuild.getNumber())
        //             env.test_link_build = "api_" + now_str + "v" + "${GALAXY_JENKINS_BUILD_VERSION}"
        //             echo "test_link_build is ${test_link_build}"

        //             echo env.resource_name
        //             proper_string=env.resource_name.split(" ")
        //             env.NODE_NAME=proper_string[0].split(":")[1]
        //             env.SERIAL_PORT=proper_string[1].split(":")[1]
        //             env.RESET_RELAY_PORT=proper_string[2].split(":")[1]
        //             env.POWER_RELAY_PORT=proper_string[3].split(":")[1]
        //             env.CONTROLLER_POWER_PORT=proper_string[4].split(":")[1]
        //             echo "Node_NAME is ${env.Node_NAME}"
        //             echo "SERIAL_PORT is ${env.SERIAL_PORT}"
        //             echo "POWER_RELAY_PORT is ${env.POWER_RELAY_PORT}"
        //             echo "RESET_RELAY_PORT is ${env.RESET_RELAY_PORT}"
        //             echo "CONTROLLER_POWER_PORT is ${env.CONTROLLER_POWER_PORT}"
        //         }
        //     }
        // }
        stage('checkout'){
            steps {
                script {
                    
                    if (fileExists(env.JSON_FILE)) {
                        echo "file exisst"
                        def read = readJSON file: env.JSON_FILE
                        if (read.finish_flag) {
                            cleanWs()
                            copyArtifacts optional: true, projectName: env.JOB_NAME, selector: lastWithArtifacts()
                            // getCode("spsd/master", "test/bluetooth.xml")
                            sh '''
                            repo init --no-clone-bundle \
                            -u ssh://gerrit-spsd.verisilicon.com:29418/manifest \
                            -b spsd/master -m test/bluetooth.xml
                            repo sync
                            echo "repo sync Automation and auto-pts"
                            cd auto-pts
                            git checkout master
                            cd ..
                            cd Automation
                            #git fetch "ssh://gerrit-spsd.verisilicon.com:29418/VSI/Automation" refs/changes/90/35190/6 && git cherry-pick FETCH_HEAD
                            #git fetch "ssh://gerrit-spsd.verisilicon.com:29418/VSI/Automation" refs/changes/91/36091/1 && git cherry-pick FETCH_HEAD
                            #git fetch "ssh://gerrit-spsd.verisilicon.com:29418/VSI/Automation" refs/changes/30/35830/15 && git cherry-pick FETCH_HEAD
                            #git fetch "ssh://gerrit-spsd.verisilicon.com:29418/VSI/Automation" refs/changes/25/36425/1 && git cherry-pick FETCH_HEAD
                            #git fetch "ssh://gerrit-spsd.verisilicon.com:29418/VSI/Automation" refs/changes/91/36091/6 && git cherry-pick FETCH_HEAD
                            git fetch ssh://gerrit-spsd.verisilicon.com:29418/VSI/Automation refs/changes/34/38034/3 && git cherry-pick FETCH_HEAD
                            cd ..
                            '''
                        }
                        echo "prepare done"
                    }
                    echo "file not exist"
                    
                }
            }
        }
        
        
        stage("Parse file") {
            steps {
                script {
                    if (fileExists(env.JSON_FILE)) {
                        echo "satrt parse"
                        def read = readJSON file: env.JSON_FILE
                        echo "json file's current_test_case is ${read.current_test_case}"
                        echo "json file's finish_flag is ${read.finish_flag}"
                        echo "json file's build_info_list is ${read.build_info_list}"
                        if (read.finish_flag) {
                            read.build_info_list = []
                            read.finish_flag = false
                        }
                        // get the cases need to run from the file test_suite.txt
                        echo "get cases"
                        sh '''
                        pwd
                        ls Automation/platforms/bttest/tests/scenario_api/config/
                        '''
                        // test_case_item_list = sh(script: '''cat Automation/platforms/bttest/tests/scenario_api/config/scenario_case_config_8H.yaml | grep "case_*"| sed 's/.$//' ''', returnStdout:true).trim().split("\n")
                        test_case_item_list = sh(script: '''cat Automation/platforms/bttest/tests/scenario_api/config/scenario_api_test/scenario_case_config.yaml | grep "case_*"| sed 's/.$//' ''', returnStdout:true).trim().split("\n")
                        //test_case_item_list = sh(script: '''cat Automation/platforms/bttest/tests/scenario_api/config/scenario_case_config.yaml | grep "case_*"| sed 's/.$//' ''', returnStdout:true).trim().split("\n")
                        echo "cases list"
                        echo "test_case_item_list is ${test_case_item_list} "
                        // test_case_item_list = readfile.split("\n")
                        int current_test_case_index = 0
                        for (int i=0; i<test_case_item_list.size(); i++) {
                            if (test_case_item_list[i] == read.current_test_case){
                                current_test_case_index = i
                            }
                        }
                        // get test time of every cases
                        // time_list = sh(script: '''cat Automation/platforms/bttest/tests/scenario_api/config/scenario_case_config_8H.yaml | grep "test_time" | awk '{print $2}' ''', returnStdout:true).trim().split("\n")
                        time_list = sh(script: '''cat Automation/platforms/bttest/tests/scenario_api/config/scenario_api_test/scenario_case_config.yaml | grep "test_time" | awk '{print $2}' ''', returnStdout:true).trim().split("\n")
                        //time_list = sh(script: '''cat Automation/platforms/bttest/tests/scenario_api/config/scenario_case_config.yaml | grep "test_time" | awk '{print $2}' ''', returnStdout:true).trim().split("\n")
                        echo "time_list is ${time_list} "
                        // calculate the index for next time
                        total_test_time = 0
                        case_end_index = 0
                        def week = new Date()[DAY_OF_WEEK]
                        echo "week is ${week.class}"
                        int test_time_hour = 12
                        if (week == 6){
                            test_time_hour = test_time_hour + 48
                            // test_time_hour = 216
                        }
                        if (week == 7){
                            test_time_hour = test_time_hour + 24
                            // test_time_hour = 216
                        }
                        // if (week == 1){
                        //     test_time_hour = test_time_hour + 11
                        //     // test_time_hour = 216
                        // }
                        int test_time_sec = test_time_hour * 60
                        echo "total test time for this round is ${test_time_sec}"
                        for (int i=current_test_case_index; i<time_list.size(); i++) {
                            case_end_index = i
                            total_test_time += Integer.parseInt(time_list[i])
                            // total test time for a round can not larger than 12h
                            if (total_test_time > test_time_sec){
                                case_end_index = i - 1
                                total_test_time -= Integer.parseInt(time_list[i])
                                break
                            }
                        }
                        // calculate the test time for next turn, if less than 1 h, execute them in this round.
                        if (case_end_index < time_list.size() -1 ){
                            total_test_time_for_next_turn = 0
                            for (int i=case_end_index + 1; i<time_list.size(); i++) {
                                total_test_time_for_next_turn += Integer.parseInt(time_list[i])
                            }
                            if (total_test_time_for_next_turn <= 60){
                                case_end_index = time_list.size() -1
                                total_test_time += total_test_time_for_next_turn
                            }
                        }
                        echo "case_end_index is ${case_end_index} "
                        
                        echo "total_test_time is ${total_test_time} "
                        // get the start case name of next turn
                        int next_run_test_case_index = case_end_index + 1
                        if (next_run_test_case_index == test_case_item_list.size()){
                            next_run_test_case_index = test_case_item_list.size()
                            read.current_test_case = test_case_item_list[0]
                            read.finish_flag=true
                        }
                        else{
                            read.current_test_case = test_case_item_list[next_run_test_case_index]
                            echo "json file's current_test_case is ${read.current_test_case}"
                        }
                        // write the cases that need to run to lltest_temp.txt
                        def temp_context = ""
                        env.CASE_LIST = ""
                        for (j=current_test_case_index; j<next_run_test_case_index; j++){
                            // temp_context=temp_context + test_case_item_list[j] + "\n"
                            temp_context = temp_context + test_case_item_list[j] + " "
                            // echo "test_case_item_list[j] is ${test_case_item_list[j]}"
                        }
                        echo "class is ${temp_context.getClass()}"
                        getResourcePram(temp_context)
                        echo "temp_context is ${temp_context} "
                        // env.CASE_LIST=temp_context
                        echo "CASE_LIST is ${env.CASE_LIST} "
                        // writeFile file: 'Linklayertest/scenario/tests/suites/lltest_temp.txt', text: temp_context
                        read.build_info_list << env.BUILD_INFO
                        // TESTLINK_BUILD_INFO is always the first build info in every turn.
                        env.TESTLINK_BUILD_INFO = read.build_info_list[0]
                        // write to json file
                        def lltestmap = ['current_test_case': read.current_test_case,
                        'finish_flag': read.finish_flag,
                        'build_info_list': read.build_info_list]
                        writeJSON file: env.JSON_FILE, json: lltestmap
                    }
                }
            }
        }

        stage('API test') {
            steps {
                script {
                    echo "API test start "
                    echo "CASE_LIST is ${env.CASE_LIST} "
                    if (fileExists(env.JSON_FILE)) {
                    def read = readJSON file: env.JSON_FILE
                    if  (read.finish_flag){
                        echo "finished"
                        }
                    else{
                        env.LLTEST_XLSX=""
                        echo "not finished"
                        }
                    }
                    sh '''
                        #!/bin/bash -il
                        export IMG_URL=${RELEASE_BUILD_PATH_URL}
                        export USER_CASES=${CASE_LIST}
                        echo ${USER_CASES}

                        # Test
                        ./Automation/core/test_main.sh bttest scenario_api_test_suites.txt
                        

                         # upload result to TestLink
                         # use for upload test link failed
                         # export TESTLINK_BUILD_INFO="20230808_2010_build108"
                        #./Automation/core/upload_test_result.sh "pulsar" "${TEST_LINK_PLAN}" "${TESTLINK_BUILD_INFO}" "genesas2"

                        # Copy result
                        ./Automation/core/copy_result.sh /workspace/spsd_file/image $cnuser:$cnpasswd
                    '''
                }
            }
        }
    }
    post {
         success {
            archiveArtifacts artifacts: env.JSON_FILE, followSymlinks: false
        }
        unstable {
            archiveArtifacts artifacts: env.JSON_FILE, followSymlinks: false
        }
        
        always {
            script {
                if (fileExists(env.JSON_FILE)) {
                    def read = readJSON file: env.JSON_FILE
                    if (read.finish_flag){
                        // get all xml from jenkins url, and then use junit to judge the xml file
                        read.build_info_list.each{
                            it
                            env.BUILD_INFO_XML = it
                            // sh 'cp ./Automation/output/scenario_api_test.sh-"${BUILD_INFO_XML}"/report.xml ./Automation/output/report/"${BUILD_INFO_XML}".xml; echo $?'
                            sh 'cp ./Automation/output/scenario_api_test.sh-"${BUILD_INFO_XML}"/report.xml "${BUILD_INFO_XML}".xml; echo $?'
                            }
                        // uncomment it if need to send email only
                        // env.TESTLINK_BUILD_INFO = "20231210_1018_build293"
                        junit '*.xml'
                        sh '''
                        # upload result to TestLink
                        ./Automation/core/upload_test_result.sh "pulsar" "${TEST_LINK_PLAN}" "${TESTLINK_BUILD_INFO}" "genesas2"
                        echo "generate report"
                        export TARGET_TEST_URL=${BUILD_URL}
                        ./Automation/core/generate_report.sh "pulsar" "${TEST_LINK_PLAN}" "${TESTLINK_BUILD_INFO}" "genesas2"
                        '''
                        def htmlexists = fileExists 'Automation/core/utils/email/report.html'
                        if(htmlexists){
                            emailext(body:'''${FILE,path="Automation/core/utils/email/report.html"}''',
                                mimeType: 'text/html',
                                subject: '$DEFAULT_SUBJECT',
                                to: '$DEFAULT_RECIPIENTS, Yanhui.Duan@verisilicon.com, Xuegen.Zou@verisilicon.com, Jian.Sima@verisilicon.com, Hao.Zhang@verisilicon.com, Maogang.Li@verisilicon.com, Shining.Xing@verisilicon.com, Jun.Zhou@verisilicon.com, Mingrui.Du@verisilicon.com',
                                // to: 'Siqi.Xie@verisilicon.com',
                                // to: 'Xin.He@verisilicon.com, Siqi.Xie@verisilicon.com',
                                attachmentsPattern: 'Automation/core/utils/email/*.xlsx');
                        }
                    }
                    
                }
            }
        }
    }
}
```