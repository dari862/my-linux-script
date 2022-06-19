
  C5 "Slack" off
  # D: Development
  D3 "GO" off
  D4 "Microsoft Visual Studio Code" off
  D5 "IntelliJ IDEA Ultimate" off
  D6 "GoLand" off
  D7 "Postman" off
  D8 "Docker" off
  D9 "Maven" off
  D12 "PyCharm" off
  D13 "Robo 3T" off
  D14 "DataGrid" off
  D15 "Mongo Shell & MongoDB Database Tools" off
  # F: Utility
  F1 "Dropbox" off
  F3 "Virtualbox" off
)

  C5)
    snap install slack --classic
    ;;
  D3)
    wget https://go.dev/dl/go1.18.linux-amd64.tar.gz
    rm -rf /usr/local/go && tar -C /usr/local -xzf go1.18.linux-amd64.tar.gz
    echo ' ' >> $HOME/.profile
    echo '# GoLang configuration ' >> $HOME/.profile
    echo 'export PATH="$PATH:/usr/local/go/bin"' >> $HOME/.profile
    echo 'export GOPATH="$HOME/go"' >> $HOME/.profile
    source $HOME/.profile
    ;;
  D4)
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
    sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
    rm -f packages.microsoft.gpg
    apt install apt-transport-https
    apt update
    apt install code # or code-insiders
    ;;
  D5)
    wget https://download.jetbrains.com/idea/ideaIU-2021.3.3.tar.gz
    tar -xzf ideaIU-2021.3.3.tar.gz -C /opt
    ln -s /opt/idea-IU-213.7172.25/bin/idea.sh /usr/local/bin/idea
    echo "[Desktop Entry]
          Version=1.0
          Type=Application
          Name=IntelliJ IDEA Ultimate Edition
          Icon=/opt/idea-IU-213.7172.25/bin/idea.svg
          Exec=/opt/idea-IU-213.7172.25/bin/idea.sh %f
          Comment=Capable and Ergonomic IDE for JVM
          Categories=Development;IDE;
          Terminal=false
          StartupWMClass=jetbrains-idea
          StartupNotify=true" >> /usr/share/applications/jetbrains-idea.desktop
    ;;
  D6)
    wget https://download.jetbrains.com/go/goland-2022.1.2.tar.gz
    tar -xzf goland-2022.1.2.tar.gz -C /opt
    ln -s /opt/GoLand-2022.1.2/bin/goland.sh /usr/local/bin/goland
    echo "[Desktop Entry]
          Version=1.0
          Type=Application
          Name=GoLand
          Icon=/opt/GoLand-2022.1.2/bin/goland.png
          Exec=/opt/GoLand-2022.1.2/bin/goland.sh
          Terminal=false
          Categories=Development;IDE;" >> /usr/share/applications/jetbrains-goland.desktop
    ;;
  D7)
    curl https://dl.pstmn.io/download/latest/linux64 --output postman-9.20.3-linux-x64.tar.gz
    tar -xzf postman-9.20.3-linux-x64.tar.gz -C /opt
    echo "[Desktop Entry]
          Encoding=UTF-8
          Name=Postman
          Exec=/opt/Postman/app/Postman %U
          Icon=/opt/Postman/app/resources/app/assets/icon.png
          Terminal=false
          Type=Application
          Categories=Development;" >> /usr/share/applications/Postman.desktop
    ;;
  D8)
    apt-get install \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg \
        lsb-release
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo \
      "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
      $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
    apt-get update
    apt-get -y install docker-ce docker-ce-cli containerd.io
    docker run hello-world

    groupadd docker
    usermod -aG docker $USER
    curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
    docker-compose --version
    ;;
  D9)
    wget https://dlcdn.apache.org/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz
    tar -zxvf apache-maven-3.6.3-bin.tar.gz
    mkdir /opt/maven
    mv ./apache-maven-3.6.3 /opt/maven/
    echo ' ' >> $HOME/.profile
    echo '# Maven Configuration' >> $HOME/.profile
    echo 'JAVA_HOME=/usr/lib/jvm/default-java' >> $HOME/.profile
    echo 'export M2_HOME=/opt/maven/apache-maven-3.6.3' >> $HOME/.profile
    echo 'export PATH=${M2_HOME}/bin:${PATH}' >> $HOME/.profile
    source $HOME/.profile
    ;;
  D12)
    snap install pycharm-community --classic
    ;;
  D13)
    snap install robo3t-snap
    ;;
  D14)
    wget https://download.jetbrains.com/datagrip/datagrip-2022.1.5.tar.gz
    tar -xzf datagrip-2022.1.5.tar.gz -C /opt
    ln -s /opt/DataGrip-2022.1.5/bin/datagrip.sh /usr/local/bin/datagrip
    cd /opt/DataGrip-2022.1.5/bin
    ./datagrip.sh
    ;;
  D15)
    wget -O mongosh.deb https://downloads.mongodb.com/compass/mongodb-mongosh_1.2.2_amd64.deb
    dpkg -i ./mongosh.deb

    wget -O mongodb-database-tools.deb https://fastdl.mongodb.org/tools/db/mongodb-database-tools-debian92-x86_64-100.5.2.deb
    dpkg -i ./mongodb-database-tools.deb
    ;;

  F1)
    wget -O dropbox.deb https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_2020.03.04_amd64.deb
    apt -y install ./dropbox.deb
    ;;
  F3)
    add-apt-repository "deb [arch=amd64] https://download.virtualbox.org/virtualbox/debian bullseye contrib"
    wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | apt-key add -
    wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | apt-key add -
    apt-get update
    apt-get -y install virtualbox-6.1
