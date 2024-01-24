# pipeline
```groovy
String randomBDAddress(){
    Random rand = new Random()
    byte[] macAddr = new byte[6]
    rand.nextBytes(macAddr)

    macAddr[0] = (byte)(macAddr[0] & (byte)254)  //zeroing last 2 bytes to make it unicast and locally adminstrated

    StringBuilder sb = new StringBuilder(18)
    for(byte b : macAddr){

         if(sb.length() > 0)
            sb.append(":")

        sb.append(String.format("%02x", b))
    }
    return sb.toString()
}

String randomBDName(int length) {
    int leftLimit = 97 // letter 'a'
    int rightLimit = 122 // letter 'z'
    Random random = new Random()
    StringBuilder buffer = new StringBuilder(length)
    for (int i = 0; i < length; i++) {
        int randomLimitedInt = leftLimit + (int)(random.nextFloat() * (rightLimit - leftLimit + 1))
        buffer.append((char) randomLimitedInt)
    }
    return buffer.toString()
}

String get_test_link_build(String url, String version) {
    def url_array = url.split("/image/")[1].split("/")
    return url_array[0] + "_"  + url_array[1] + "_v" + version
}

pipeline {
    agent none
    options {
        timestamps()
        lock(label: "rigel_a0_board", quantity: 1, variable: "resource_name")
    }
    environment {
        testlink_db_password=credentials('testlink_db_password')
        testlink_api_devkey=credentials('Testlink_API_Devkey')
        testlink_api_test_devkey=credentials('Testlink_API_Test_Devkey')

    }
    stages {
        stage('GetNodeName'){
            steps{
                script{
                    echo env.resource_name
                    proper_string=env.resource_name.split(" ")
                    env.NODE_NAME=proper_string[0].split(":")[1]
                }
            }
        }
        stage('CleanWorkspace'){
            agent { label "${NODE_NAME}" }
            steps{
                cleanWs()
            }
        }
        stage('checkout'){
            agent { label "${NODE_NAME}" }
            steps {
                script {
                    def url = "${RELEASE_BUILD_PATH_URL}"
                    def vv = "${GALAXY_JENKINS_BUILD_VERSION}"
                    env.test_link_build = get_test_link_build(url, vv)
                    env.IUT_BD_ADDR = randomBDAddress()
                    env.IUT_BD_NAME = randomBDName(10)
                    echo "IUT_BD_ADDR is ${IUT_BD_ADDR}"
                    echo "IUT_BD_NAME is ${IUT_BD_NAME}"
                    echo env.resource_name
                    proper_string=env.resource_name.split(" ")
                    env.NODE_NAME=proper_string[0].split(":")[1]
                    env.SERIAL_PORT=proper_string[1].split(":")[1]
                    env.RESET_RELAY_PORT=proper_string[2].split(":")[1]
                    env.POWER_RELAY_PORT=proper_string[3].split(":")[1]
                    env.CSV_FILE = "${CSV_FILE}"
                    env.TEST_PROJECT = "${TEST_PROJECT}"
                    env.TEST_LINK_PLAN = "${TEST_LINK_PLAN}"
                    env.TEST_LINK_PLATFORM = "${TEST_LINK_PLATFORM}"
                    echo "Node_NAME is ${env.Node_NAME}"
                    echo "SERIAL_PORT is ${env.SERIAL_PORT}"
                    echo "POWER_RELAY_PORT is ${env.POWER_RELAY_PORT}"
                    echo "RESET_RELAY_PORT is ${env.RESET_RELAY_PORT}"
                    sh '''
                    #!/bin/bash -il
                    rm -rf Automation
                    git clone "ssh://gerrit-spsd.verisilicon.com:29418/VSI/Automation"
                    echo "checkout automation"
                    '''
                }
            }
        }
        stage('common test') {
            agent { label "${NODE_NAME}" }
            steps {
                catchError{
                    script {
                    def url = "${RELEASE_BUILD_PATH_URL}"
                    def vv = "${GALAXY_JENKINS_BUILD_VERSION}"
                    def test_link_build = get_test_link_build(url, vv)
                    echo "test_link_build is ${test_link_build}"
                    def common_test = build job: "a0_common_test", parameters: [
                        string(name: 'RELEASE_BUILD_PATH_URL', value: "${RELEASE_BUILD_PATH_URL}"),
                        string(name: 'GALAXY_JENKINS_BUILD_VERSION', value: "${GALAXY_JENKINS_BUILD_VERSION}"),
                        string(name: 'TEST_LINK_PLAN', value: "${TEST_LINK_PLAN}"),
                        string(name: 'TEST_LINK_PLATFORM', value: "${TEST_LINK_PLATFORM}"),
                        string(name: 'TEST_PROJECT', value: "${TEST_PROJECT}"),
                        string(name: 'CSV_FILE', value: "${CSV_FILE}"),
                        string(name: 'IUT_BD_ADDR', value: "${IUT_BD_ADDR}"),
                        string(name: 'IUT_BD_NAME', value: "${IUT_BD_NAME}"),
                        string(name: 'resource_name', value: "${resource_name}")
                        ]
                    def commonjobResult = common_test.getResult()
                    env.commonjobResult = commonjobResult
                    echo "Build of ${TEST_PROJECT}_common_test returned result: ${commonjobResult}"

                    }
                }
            }
        }
        stage('pts test'){
            agent { label "${NODE_NAME}" }
            when {
                environment name: 'commonjobResult',
                value: 'SUCCESS'
            }
            steps {
                catchError{
                script {
                    echo "IUT_BD_ADDR value is ${IUT_BD_ADDR}"
                    String bd_addr = IUT_BD_ADDR.replaceAll(":", "")
                    def url = "${RELEASE_BUILD_PATH_URL}"
                    def vv = "${GALAXY_JENKINS_BUILD_VERSION}"
                    def test_link_build = get_test_link_build(url, vv)
                    echo "test_link_build is ${test_link_build}"
                    def pts_test = build job: "pts_pipeline_test", parameters: [
                        string(name: 'PTS_SERVER_IP', value: "10.10.179.122"),
                        string(name: 'PTS_CLIENT_IP', value: "10.10.179.191"),
                        string(name: 'PTS_IUT_BR_ADDRESS', value: "${bd_addr}"),
                        string(name: 'PTS_WORKSPACE_PATH', value: "C:/Users/jenkins-spsd-auto/Pts_Test/rigel/rigel.pqw6"),
                        string(name: 'PTS_WINDOWS_JOB', value: "pts_windows_test"),
                        string(name: 'PTS_LINUX_JOB', value: "rigel_a0_pts_test"),
                        string(name: 'RELEASE_BUILD_PATH_URL', value: "${RELEASE_BUILD_PATH_URL}"),
                        string(name: 'PTS_TEST_CASES', value: "SM"),
                        string(name: 'TEST_LINK_BUILD', value: "${test_link_build}"),
                        string(name: 'TEST_LINK_PLAN', value: "${TEST_LINK_PLAN}"),
                        string(name: 'SERIAL_PORT', value: "${SERIAL_PORT}"),
                        string(name: 'POWER_RELAY_PORT', value: "${POWER_RELAY_PORT}"),
                        string(name: 'RETRY', value: "2"),
                        string(name: 'BOARD', value: "rigel")
                        ]
                    def jobResult = pts_test.getResult()
                    echo "Build of pts_pipeline_test returned result: ${jobResult}"
                    }
                }
            }
        }
        // stage('app test'){
        //     agent { label "${NODE_NAME}" }
        //     when {
        //         environment name: 'commonjobResult',
        //         value: 'SUCCESS'
        //     }
        //     steps{
        //         catchError {
        //         script {
        //             def url = "${RELEASE_BUILD_PATH_URL}"
        //             def vv = "${GALAXY_JENKINS_BUILD_VERSION}"
        //             def test_link_build = get_test_link_build(url, vv)
        //             echo "test_link_build is ${test_link_build}"
        //             def bd_addr = IUT_BD_ADDR.toUpperCase()
        //             echo "bd_addr is ${bd_addr}"
        //             def ota_image_url = url + "Rigel.img"
        //             echo "ota_image_url is ${ota_image_url}"
        //             //hard code the url to get apk
        //             apk_url = "http://jenkins-spsd.verisilicon.com/image/rigel_a0/20211028_1820_build958/image/"
        //             def board_test = build job: "rigel_app_test", parameters: [
        //                 string(name: 'RELEASE_BUILD_PATH_URL', value: "${apk_url}"),
        //                 string(name: 'SERIAL_PORT', value: "${SERIAL_PORT}"),
        //                 string(name: 'PHONE_SERIAL_NUMBER', value: "MYQUT20330007081"),
        //                 string(name: 'BD_ADDRESS', value: "${bd_addr}"),
        //                 string(name: 'UART_BAUD_RATE', value: "115200"),
        //                 string(name: 'TEST_LINK_BUILD', value: "${test_link_build}"),
        //                 string(name: 'TEST_LINK_PLAN', value: "${TEST_LINK_PLAN}"),
        //                 string(name: 'OTA_IMAGE_URL', value: "${ota_image_url}"),
        //                 string(name: 'OTA_REPEAT', value: "1"),
        //                 string(name: 'CONNECTION_REPEAT', value: "20")
        //                 ]
        //             def jobResult = board_test.getResult()
        //             echo "Build of rigel_board_test returned result: ${jobResult}"
        //             }
        //         }
        //     }
        // }
        stage('post'){
            agent { label "${NODE_NAME}" }
            steps{
                script{
                    sh '''
                        #!/bin/bash -il
                        echo "generate report"
                        export TARGET_TEST_URL=${BUILD_URL}
                        #export TEST_LINK_TEST_ENV="y"
                        #export testlink_db_password="123456"
                        #export testlink_api_devkey="f4555ac175ae6eea0592baf4d9d9518d"
                        # generate report
                        ./Automation/core/generate_report.sh "${TEST_PROJECT}" "${TEST_LINK_PLAN}"  "${test_link_build}" "${TEST_LINK_PLATFORM}"
                    '''
                    def exists = fileExists 'Automation/core/utils/email/report.html'
                    if(exists){
                        emailext(body:'''${FILE,path="Automation/core/utils/email/report.html"}''',
                            mimeType: 'text/html',
                            subject: '$DEFAULT_SUBJECT',
                            to: '$DEFAULT_RECIPIENTS, Hao.Zhang@verisilicon.com, Alex.Lin@verisilicon.com, Alex.Xie@verisilicon.com, Jun.Zhou@verisilicon.com, Jian.Sima@verisilicon.com, Lucas.Wang@verisilicon.com',
                            //to: 'miao.huang@verisilicon.com',
                            attachmentsPattern: 'Automation/core/utils/email/*.xlsx');
                    }else{
                        emailext(body:'''Failed early, generate report failed''',
                            subject: '$DEFAULT_SUBJECT',
                            to: 'miao.huang@verisilicon.com');
                        }
                    }
                    
                }
            }
        }
    }
```
## interpret
这段代码是一个Jenkins Pipeline脚本的一部分，它包含了以下内容：

1. `agent none`：指定在该阶段中不使用任何Jenkins节点。这意味着该阶段不会在任何特定的节点上执行，而是在Jenkins的控制节点上执行。
    
2. `options`：定义了一些选项配置。
    
    - `timestamps()`：在控制台输出中添加时间戳，用于记录每个步骤的执行时间。
        
    - `lock(label: "rigel_a0_board", quantity: 1, variable: "resource_name")`：使用锁来限制并发执行。这里使用了一个名为"rigel_a0_board"的锁，限制了同时只能有一个构建任务使用该锁，并将锁的状态存储在名为"resource_name"的变量中3. `environment`：定义了一些环境变量。
        
    - `testlink_db_password=credentials('testlink_db_password')`：将名为"testlink_db_password"的凭据赋值给环境变量`testlink_db_password`。
        
    - `testlink_api_devkey=credentials('Testlink_API_Devkey')`：将名为"Testlink_API_Devkey"的凭据赋值给环境变量`testlink_api_devkey`。
        
    - `testlink_api_test_devkey=credentials('Testlink_API_Test_Devkey')`：将名为"Testlink_API_Test_Devkey"的凭据赋值给环境变量`testlink_api_test_devkey`。
        

这段代码的作用是在Jenkins Pipeline中定义了一个阶段，其中不使用任何Jenkins节点来执行任务。同时，通过选项配置添加了时间戳和锁的限制，并通过环境变量定义了一些凭据信息，以便在后续的步骤中使用。

这段代码是一个Jenkins Pipeline脚本的一部分，它包含了两个阶段：'GetNodeName'和'CleanWorkspace'。下面是对这段代码的解释：

1. 阶段 'GetNodeName'：
    
    - `steps`：定义了在该阶段中要执行的步骤。
        
    - `script`：定义了一个脚本块，包含了要在该阶段中执行的代码。
        
    - `echo env.resource_name`：打印出环境变量 `resource_name` 的值。
        
    - `proper_string=env.resource_name.split(" ")`：将环境变量 `resource_name` 的值按空格进行分割，并将结果赋给变量 `proper_string`。
        
    - `env.NODE_NAME=proper_string[0].split(":")[1]`：将 `proper_string` 的第一个元素按冒号进行分割，并将分割结果的第二个元素赋给环境变量 `NODE_NAME`。
        
2. 阶段 'CleanWorkspace'：
    
    - `agent { label "${NODE_NAME}" }`：指定了在哪个Jenkins节点上运行该阶段。`${NODE_NAME}`是一个变量，表示在前一个阶段 'GetNodeName' 中获取的节点名称。
        
    - `steps`：定义了在该阶段中要执行的步骤。
        
    - `cleanWs()`：执行了一个名为 `cleanWs` 的步骤，用于清理工作空间，删除之前构建产生的文件和目录。
        

这段代码的作用是在 Jenkins Pipeline 中定义了两个阶段。首先，在 'GetNodeName' 阶段中，获取环境变量 `resource_name` 的值，并根据特定的格式进行处理，提取出节点名称，并将其存储在环境变量 `NODE_NAME` 中。然后，在 'CleanWorkspace' 阶段中，使用之前获取的节点名称来指定在哪个节点上执行清理工作空间的操作。
这段代码是一个Jenkins Pipeline脚本的一部分，它包含了一个名为 'checkout' 的阶段。下面是对这段代码的解释：

- `agent { label "${NODE_NAME}" }`：指定了在哪个Jenkins节点上运行该阶段。`${NODE_NAME}`是一个变量，表示在之前的阶段中获取的节点名称。
    
- `steps`：定义了在该阶段中要执行的步骤。
    
- `script`：定义了一个脚本块，包含了要在该阶段中执行的代码。
    
- `def url = "${RELEASE_BUILD_PATH_URL}"`：定义了一个变量 `url`，其值为环境变量 `RELEASE_BUILD_PATH_URL` 的值。
    
- `def vv = "${GALAXY_JENKINS_BUILD_VERSION}"`：定义了一个变量 `vv`，其值为环境变量 `GALAXY_JENKINS_BUILD_VERSION` 的值。
    
- `env.test_link_build = get_test_link_build(url, vv)`：调用了一个名为 `get_test_link_build` 的函数，传入 `url` 和 `vv` 作为参数，并将返回值赋给环境变量 `test_link_build`。
    
- `env.IUT_BD_ADDR = randomBDAddress()`：调用了一个名为 `randomBDAddress` 的函数，并将返回值赋给环境变量 `IUT_BD_ADDR`。
    
- `env.IUT_BD_NAME = randomBDName(10)`：调用了一个名为 `randomBDName` 的函数，传入参数 `10`，并将返回值赋给环境变量 `IUT_BD_NAME`。
    
- `echo "IUT_BD_ADDR is ${IUT_BD_ADDR}"` 和 `echo "IUT_BD_NAME is ${IUT_BD_NAME}"`：打印出环境变量 `IUT_BD_ADDR` 和 `IUT_BD_NAME` 的值。
    
- `echo env.resource_name`：打印出环境变量 `resource_name` 的值。
    
- `proper_string=env.resource_name.split(" ")`：将环境变量 `resource_name` 的值按空格进行分割，并将结果赋给变量 `proper_string`。
    
- `env.NODE_NAME=proper_string[0].split(":")[1]`：将 `proper_string` 的第一个元素按冒号进行分割，并将分割结果的第二个元素赋给环境变量 `NODE_NAME`。
    
- `env.SERIAL_PORT=proper_string[1].split(":")[1]`：将 `proper_string` 的第二个元素按冒号进行分割，并将分割结果的第二个元素赋给环境变量 `SERIAL_PORT`。
    
- `env.RESET_RELAY_PORT=proper_string[2].split(":")[1]`：将 `proper_string` 的第三个元素按冒号进行分割，并将分割结果的第二个元素赋给环境变量 `RESET_RELAY_PORT`。
    
- `env.POWER_RELAY_PORT=proper_string[3].split(":")[1]`：将 `proper_string` 的第四个元素按冒号进行分割，并将分割结果的第二个元素赋给环境变量 `POWER_RELAY_PORT`。
    
- `env.CSV_FILE = "${CSV_FILE}"`：将环境变量 `CSV_FILE` 的值赋给环境变量 `CSV_FILE`。
    
- `env.TEST_PROJECT = "${TEST_PROJECT}"`：将环境变量 `TEST_PROJECT` 的值赋给环境变量 `TEST_PROJECT`。
    
- `env.TEST_LINK_PLAN = "${TEST_LINK_PLAN}"`：将环境变量 `TEST_LINK_PLAN` 的值赋给环境变量 `TEST_LINK_PLAN`。
    
- `env.TEST_LINK_PLATFORM = "${TEST_LINK_PLATFORM}"`：将环境变量 `TEST_LINK_PLATFORM` 的值赋给环境变量 `TEST_LINK_PLATFORM`。
    
- `echo "Node_NAME is ${env.Node_NAME}"`、`echo "SERIAL_PORT is ${env.SERIAL_PORT}"`、`echo "POWER_RELAY_PORT is ${env.POWER_RELAY_PORT}"`、`echo "RESET_RELAY_PORT is ${env.RESET_RELAY_PORT}"`：打印出环境变量 `NODE_NAME`、`SERIAL_PORT`、`POWER_RELAY_PORT` 和 `RESET_RELAY_PORT` 的值。
    
- `sh ''' #!/bin/bash -il rm -rf Automation git clone "ssh://gerrit-spsd.verisilicon.com:29418/VSI/Automation" echo "checkout automation" '''`：执行了一个Shell脚本，删除名为 "Automation" 的目录，并通过Git克隆了一个名为 "Automation" 的代码仓库。
    

这段代码的作用是在 Jenkins Pipeline 中定义了一个名为 'checkout' 的阶段。首先，它获取了一些环境变量的值，并进行了一些处理和赋值操作。然后，它打印出一些环境变量的值。最后，它执行了一个Shell脚本，用于从Git仓库中克隆代码。
这段代码是一个Jenkins流水线中的一个阶段（stage），名为"common test"。它包含了一系列步骤（steps），用于执行一些测试相关的操作。

在这个阶段中，首先使用了Jenkins的代理（agent）来指定运行该阶段的节点（label "��������"）。然后，在�����中使用了����ℎ�����来捕获可能发生的错误。在����ℎ�����的代码块中，定义了一些变量���和��，分别赋值为"NODEN​AME"）。然后，在steps中使用了catchError来捕获可能发生的错误。在catchError的代码块中，定义了一些变量url和vv，分别赋值为"{RELEASE_BUILD_PATH_URL}"和"${GALAXY_JENKINS_BUILD_VERSION}"。接下来，调用了一个名为get_test_link_build的函数，传入url和vv作为参数，并将返回值赋给了变量test_link_build。然后，使用build函数执行了一个名为"a0_common_test"的任务，并传入了一系列参数。最后，通过getResult函数获取了common_test任务的结果，并将结果赋给了变量commonjobResult。最后，将commonjobResult赋值给了环境变量env.commonjobResult，并打印了一条相关信息。

需要注意的是，这段代码中使用了一些变量，如"�������������������"和"RELEASEB​UILDP​ATHU​RL"和"{GALAXY_JENKINS_BUILD_VERSION}"，它们可能是在其他地方定义的，这里只是使用了它们的值。另外，代码中还调用了一个名为get_test_link_build的函数，但该函数的具体实现并未提供，所以无法确定其功能和返回值。
这段代码是Jenkins流水线中的另一个阶段（stage），名为"pts test"。它在执行之前会检查前一个阶段的结果，只有当前一个阶段的结果为"SUCCESS"时才会执行。

在这个阶段中，首先使用了Jenkins的代理（agent）来指定运行该阶段的节点（label "${NODE_NAME}"）。然后，在when块中使用了环境变量commonjobResult的值来判断是否执行该阶段。只有当commonjobResult的值为"SUCCESS"时，才会继续执行该阶段的步骤。

在steps中使用了catchError来捕获可能发生的错误。在catchError的代码块中，首先打印了"IUT_BD_ADDR value is ���������"的信息。然后，使用����������函数将变量���������中的冒号（":"）替换为空字符串，将结果赋给了变量������。接下来，定义了变量���和��，分别赋值为"IUTB​DA​DDR"的信息。然后，使用replaceAll函数将变量IUTB​DA​DDR中的冒号（":"）替换为空字符串，将结果赋给了变量bda​ddr。接下来，定义了变量url和vv，分别赋值为"{RELEASE_BUILD_PATH_URL}"和"${GALAXY_JENKINS_BUILD_VERSION}"。然后，调用了一个名为get_test_link_build的函数，传入url和vv作为参数，并将返回值赋给了变量test_link_build。接着，使用build函数执行了一个名为"pts_pipeline_test"的任务，并传入了一系列参数。最后，通过getResult函数获取了pts_test任务的结果，并将结果赋给了变量jobResult。最后，打印了一条相关信息。

需要注意的是，这段代码中使用了一些变量，如"���������"、"IUTB​DA​DDR"、"{RELEASE_BUILD_PATH_URL}"和"${GALAXY_JENKINS_BUILD_VERSION}"，它们可能是在其他地方定义的，这里只是使用了它们的值。另外，代码中还调用了一个名为get_test_link_build的函数，但该函数的具体实现并未提供，所以无法确定其功能和返回值。
这段代码是Jenkins流水线中的另一个阶段（stage），名为"post"。它在执行之前会检查前一个阶段的结果，只有当前一个阶段执行成功时才会执行。

在这个阶段中，首先使用了Jenkins的代理（agent）来指定运行该阶段的节点（label "��������"）。然后，在�����中使用了������块来执行一段���ℎ脚本。该脚本首先打印了"��������������"的信息，然后导出了一个名为�������������的环境变量，其值为"NODEN​AME"）。然后，在steps中使用了script块来执行一段Bash脚本。该脚本首先打印了"generatereport"的信息，然后导出了一个名为TARGETT​ESTU​RL的环境变量，其值为"{BUILD_URL}"。接着，调用了一个名为generate_report.sh的脚本，并传入了一系列参数。最后，使用了fileExists函数检查了一个名为Automation/core/utils/email/report.html的文件是否存在，并根据结果发送了邮件。

需要注意的是，该脚本中有一些注释掉的代码，如export TEST_LINK_TEST_ENV="y"、export testlink_db_password="123456"和export testlink_api_devkey="f4555ac175ae6eea0592baf4d9d9518d"，这些代码可能是用于测试或调试的，实际运行时可能需要将其注释掉或删除。

另外，该脚本中调用了一个名为generate_report.sh的脚本，但该脚本的具体实现并未提供，所以无法确定其功能和返回值。
1. `randomBDAddress()`: 该函数用于生成一个随机的蓝牙设备地址（BD Address）。它首先创建一个`Random`对象，然后生成一个长度为6的字节数组`macAddr`，并使用`rand.nextBytes(macAddr)`来填充数组。接下来，将`macAddr`的第一个字节的最后两位清零，以确保生成的地址是单播（unicast）和本地管理（locally administered）的。然后，使用`StringBuilder`来构建一个长度为18的字符串，通过迭代`macAddr`中的每个字节，将其转换为十六进制格式，并添加到字符串中。最后，将构建好的字符串返回。
    
2. `randomBDName(int length)`: 该函数用于生成一个指定长度的随机蓝牙设备名称（BD Name）。它首先定义了两个变量`leftLimit`和`rightLimit`，分别表示字母'a'和'z'的ASCII码值。然后，创建一个`Random`对象，并使用`StringBuilder`来构建一个指定长度的字符串。通过循环，每次生成一个介于`leftLimit`和`rightLimit`之间的随机整数，将其转换为对应的字符，并添加到字符串中。最后，将构建好的字符串返回。
    
3. `get_test_link_build(String url, String version)`: 该函数用于根据给定的URL和版本号生成一个测试链接构建名称。它首先将URL按照"/image/"进行分割，然后再将分割后的结果按照"/"进行分割，得到一个字符串数组`url_array`。最后，将`url_array`中的元素拼接起来，并添加一些固定的字符串，形成最终的构建名称，并将其返回。


# pts_pipeline
```groovy
def PTS_WINDOWS_JOB_WORKSPACE
pipeline {
    agent { label 'pts_linux_node' }
    options {
        timestamps()
        lock(label: "pts_dongle")
    }
    environment {
        JENKINS_SPSD_KEY=credentials('jenkins-spsd-key')
        OPT_BACKUP_NODE = "192.168.102.111"
        OPT_BACKUP_USERNAME = "cn1948"
    }
    stages {
        stage ('PTS Windows Job') {
            steps {
                script {
                    def jobBuild = build wait: false, job: "${PTS_WINDOWS_JOB}"
                    def jobName = "${PTS_WINDOWS_JOB}"
                    echo "jobName is ${jobName}"
                    def buildNumber = Jenkins.instance.getItem(jobName).lastBuild.number
                    def num = buildNumber + 1
                    env.PTS_WINDOWS_JOB_BUILD_NUM = num.toString()
                    echo "${PTS_WINDOWS_JOB} buildNum is ${PTS_WINDOWS_JOB_BUILD_NUM}"
                    PTS_WINDOWS_JOB_WORKSPACE = Jenkins.instance.getItem(jobName).lastBuild.workspace.toString().replace("\\","/")
                    echo "job workspace is ${PTS_WINDOWS_JOB_WORKSPACE}"
                    sleep(50)
                }
            }
        }
        stage ('PTS Linux Job') {
            steps {
                script {
                    def build_workspace = "${PTS_WINDOWS_JOB_WORKSPACE}"
                    echo "windows build_workspace is ${build_workspace}"
                    echo "RELEASE_BUILD_PATH_URL is ${RELEASE_BUILD_PATH_URL}"
                    echo "PTS_WORKSPACE_PATH is ${PTS_WORKSPACE_PATH}"
                    echo "PTS_TEST_CASES is ${PTS_TEST_CASES}"
                    def linux_build = build job: "${PTS_LINUX_JOB}", parameters: [
                        string(name: 'PTS_SERVER_IP', value: "${PTS_SERVER_IP}"),
                        string(name: 'PTS_CLIENT_IP', value: "${PTS_CLIENT_IP}"),
                        string(name: 'PTS_IUT_BR_ADDRESS', value: "${PTS_IUT_BR_ADDRESS}"),
                        string(name: 'PTS_WORKSPACE_PATH', value: "${PTS_WORKSPACE_PATH}"),
                        string(name: 'PTS_TEST_CASES', value: "${PTS_TEST_CASES}"),
                        string(name: 'PTS_WINDOWS_JOB_WORKSPACE', value:build_workspace.toString()),
                        string(name: 'RELEASE_BUILD_PATH_URL', value: "${RELEASE_BUILD_PATH_URL}"),
                        string(name: 'TEST_LINK_BUILD', value: "${TEST_LINK_BUILD}"),
                        string(name: 'TEST_LINK_PLAN', value: "${TEST_LINK_PLAN}"),
                        string(name: 'SERIAL_PORT', value: "${SERIAL_PORT}"),
                        string(name: 'POWER_RELAY_PORT', value: "${POWER_RELAY_PORT}"),
                        string(name: 'RETRY', value: "${RETRY}"),
                        string(name: 'BOARD', value: "${BOARD}")
                        ]

                    def jobResult = linux_build.getResult()
                    echo "Build of ${PTS_LINUX_JOB} returned result: ${jobResult}"
                }
            }
        }
    }
    post {
        always {
            script {
                echo "${PTS_WINDOWS_JOB} buildNum is ${PTS_WINDOWS_JOB_BUILD_NUM}"
                sh '''curl -X POST -L --user jenkins-spsd:$JENKINS_SPSD_KEY ${JENKINS_URL}/job/${PTS_WINDOWS_JOB}/"${PTS_WINDOWS_JOB_BUILD_NUM}"/stop >/dev/null'''
            }

        }
    }
}
```
##
这段代码是一个Jenkins Pipeline脚本，用于在Jenkins中执行一系列的构建任务。

首先，定义了一个名为`PTS_WINDOWS_JOB_WORKSPACE`的变量，用于存储Windows构建任务的工作空间路径。

然后，定义了一个Pipeline，其中包含了两个阶段（stage）：`PTS Windows Job`和`PTS Linux Job`。

在`PTS Windows Job`阶段中，使用`build`函数异步地触发一个名为`${PTS_WINDOWS_JOB}`的构建任务，并将构建任务的名称存储在`jobName`变量中。然后，通过`Jenkins.instance.getItem(jobName).lastBuild.number`获取构建任务的最后一次构建编号，并将其加1后存储在`num`变量中。接下来，将`num`转换为字符串，并将其存储在环境变量`PTS_WINDOWS_JOB_BUILD_NUM`中。最后，通过`Jenkins.instance.getItem(jobName).lastBuild.workspace.toString().replace("\\","/")`获取构建任务的工作空间路径，并将其存储在`PTS_WINDOWS_JOB_WORKSPACE`变量中。

在`PTS Linux Job`阶段中，首先将`PTS_WINDOWS_JOB_WORKSPACE`赋值给`build_workspace`变量。然后，使用`build`函数触发一个名为`${PTS_LINUX_JOB}`的构建任务，并传递一系列参数。其中包括了之前定义的一些环境变量，以及其他一些参数。最后，通过`linux_build.getResult()`获取构建任务的结果，并将结果存储在`jobResult`变量中。

在`post`部分，使用`always`块中的脚本，输出`PTS_WINDOWS_JOB_BUILD_NUM`的值，并使用`curl`命令向Jenkins发送一个POST请求，用于停止`${PTS_WINDOWS_JOB}`构建任务。