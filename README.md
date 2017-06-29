1. SETAUP ANIBLE and ANIBLE USER am2

install ansible on your local computer: http://docs.ansible.com/ansible/intro_installation.html

setup user on remoute server (or virtual mashine):
sudo groupadd wheel
echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

useradd -m  -s /bin/bash am2
mkdir /home/am2/.ssh/
touch /home/am2/.ssh/authorized_keys
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC/jQ0qco1q8Ws8U3L6u4GSALQNLDDuc3BIH6AtR3NhPWZE/cd2JeIhnhQX2z/2hGhLqowfvrIR9r7D9binFwD8V0rteYjjo/Ju0N5tAtJNMNxGAqKqhgOTFeakzO9SPYzNv4DfpLsRMB5XtaKg8N0RyukAHWXd6yJFZOlWtS7SZgV24knma3xxV0FlnFchhmxED7K+NR+UNVp+FytB5/C+QAhFi0kKDuYLaQapQF7NT5BISA5PY/nbxSuqWRYep5L+LizEBW9OYTjgpOzhH4M3u8SioOWZMtHrYvu9enRns9h/4JWWU9QdgXtxzH2J1UDnUVrCIsEaGU6BAZt9I0fj" >> /home/am2/.ssh/authorized_keys
chown -R am2:am2 /home/am2/.ssh/
chmod 700 /home/am2/.ssh
chmod 600 /home/am2/.ssh/authorized_keys
usermod -a -G wheel am2

INFO: If you want to use your own public key, please replace am2.key with your own key and change private key in command above. 

2. SETUP INVENTORY ( invetory.ini )

how to setup inventory: http://docs.ansible.com/ansible/intro_inventory.html

base to setup is
[apache-server] - servers list where we want apache + magento2
[nginx-server]  - servers list where we want nginx + magento2
[mariadb-server] - server list where we want database ( you can list same servers as we use for web server and instal database inside each one )
[php7-server]  - list all web servers, in progress to give option with php5.6


3. TEST ANSIBLE CONNECTION and execution

ansible apache-server -i ./inventory.ini --private-key="am2.key" -m ping
ansible nginx-server  -i ./inventory.ini --private-key="am2.key" -m ping

ansible apache-server -i ./inventory.ini --private-key="am2.key" -m command -a "/bin/echo Hello from remoute box"
ansible nginx-server  -i ./inventory.ini --private-key="am2.key" -m command -a "/bin/echo Hello from remoute box"


4. Start install web servers

ansible-playbook -i ./inventory.ini --private-key="am2.key" webservers.yml


5. Setup Database

ansible-playbook -i ./inventory.ini --private-key="am2.key" database.yml

INFO: ansible wont setup root sure, but will install python module to control databases and users from ansible configuration and tasks


6. Setup Magento 2

6.1 Setup your public and private key

vars/magento/access_key.yml

---
account_public_key: YOUR_MAGENTO_PUBLIC_KEY
account_private_key: YOUR_MAGENTO_PRIVATE_KEY
how to get keys: http://devdocs.magento.com/guides/v2.0/install-gde/prereq/connect-auth.html

6.2 Setup database configration and backend user ( not required to change )

vars/magento/config.yml
default backend user:
user: admin
pass: abraK4adabra

6.3 Run setup

ansible-playbook -i ./inventory.ini --private-key="am2.key" magento2.yml


7. Configure and install new relic

update your licence key vars/newrelic/license_key.yml
license_key: NEW_RELIC_LICENCE_KEY_HERE

how to get new relic licence key: https://docs.newrelic.com/docs/accounts-partnerships/accounts/account-setup/license-key

ansible-playbook -i ./inventory.ini --private-key="am2.key" newrelic.yml

8. run test
* require apache banchmark application to be installed

troubleshuting:
if you have trouble with timeout please edit test.sh and configure higer timeout.

home page
./test.sh > results/test-1-1-apache-nginx-home-sampledata.html
./test.sh > results/test-1-2-apache-nginx-home-sampledata.html
./test.sh > results/test-1-3-apache-nginx-home-sampledata.html

category page
./test.sh women/tops-women/jackets-women.html > test-2-1-apache-nginx-women-tops-women-jackets-women.html
./test.sh women/tops-women/jackets-women.html > test-2-2-apache-nginx-women-tops-women-jackets-women.html
./test.sh women/tops-women/jackets-women.html > test-2-3-apache-nginx-women-tops-women-jackets-women.html

product page
./test.sh adrienne-trek-jacket.html > test-3-1-product-page.html
./test.sh adrienne-trek-jacket.html > test-3-2-product-page.html
./test.sh adrienne-trek-jacket.html > test-3-3-product-page.html


add to cart
* require to disable form key
edit: vendor/magento/module-checkout/Controller/Cart/Add.php
and comment line 80-82. REMEBER TO REMOVE COMMENT AFTER TEST!!
<pre>
    public function execute()
    {
        if (!$this->_formKeyValidator->validate($this->getRequest())) {
            return $this->resultRedirectFactory->create()->setPath('*/*/');
        }
</pre>
in progress to get form key from product page.

./test.sh checkout/cart/add/product/6/qty/1 > test-4-1-add-product-to-cart.html
./test.sh checkout/cart/add/product/6/qty/1 > test-4-2-add-product-to-cart.html
./test-add-product-to-cart-edge.sh  > test-4-3-add-product-to-cart.html



