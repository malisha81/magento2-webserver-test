<h2> SETUP ANIBLE and ANIBLE USER am2 </h2>

install ansible on your local computer: http://docs.ansible.com/ansible/intro_installation.html

setup user on remoute server (or virtual mashine):
<pre>
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
</pre>

INFO: If you want to use your own public key, please replace am2.key with your own key and change private key in command above. 

<h2> SETUP INVENTORY ( invetory.ini ) </h2>

how to setup inventory: http://docs.ansible.com/ansible/intro_inventory.html

base to setup is<br />
[apache-server] - servers list where we want apache + magento2<br />
[nginx-server]  - servers list where we want nginx + magento2<br />
[mariadb-server] - server list where we want database ( you can list same servers as we use for web server and instal database inside each one )<br />
[php7-server]  - list all web servers, in progress to give option with php5.6<br />


<h2> TEST ANSIBLE CONNECTION and execution </h2>

<pre>
ansible apache-server -i ./inventory.ini --private-key="am2.key" -m ping
ansible nginx-server  -i ./inventory.ini --private-key="am2.key" -m ping

ansible apache-server -i ./inventory.ini --private-key="am2.key" -m command -a "/bin/echo Hello from remoute box"
ansible nginx-server  -i ./inventory.ini --private-key="am2.key" -m command -a "/bin/echo Hello from remoute box"
</pre>

<h2> Setup web servers </h2>

<pre>ansible-playbook -i ./inventory.ini --private-key="am2.key" webservers.yml</pre>


<h2> Setup Database </h2>

<pre>ansible-playbook -i ./inventory.ini --private-key="am2.key" database.yml</pre>

INFO: Ansible will not setup root user, but will install python module to control databases and users from ansible configuration and tasks


<h2> Setup Magento 2 </h2>

<h3> Setup your public and private key </h3>

<pre>
vars/magento/access_key.yml

account_public_key: YOUR_MAGENTO_PUBLIC_KEY
account_private_key: YOUR_MAGENTO_PRIVATE_KEY
</pre>

how to get keys: http://devdocs.magento.com/guides/v2.0/install-gde/prereq/connect-auth.html

<h3> Setup database configration and backend user ( not required to change ) </h3>

<pre>
vars/magento/config.yml

default backend user:
user: admin
pass: abraK4adabra
</pre>

<h3> Run setup </h3>

<pre>ansible-playbook -i ./inventory.ini --private-key="am2.key" magento2.yml</pre>


<h2> Configure and install new relic </h2>

<pre>
update your licence key vars/newrelic/license_key.yml
license_key: NEW_RELIC_LICENCE_KEY_HERE
</pre>

how to get new relic licence key: https://docs.newrelic.com/docs/accounts-partnerships/accounts/account-setup/license-key

<pre>ansible-playbook -i ./inventory.ini --private-key="am2.key" newrelic.yml</pre>

<h2> run test </h2>

* require apache banchmark application to be installed
* add server list in  test.cfg


troubleshuting:
if you have trouble with timeout please edit test.sh and increase timeout.


<h4>home page</h4>
<pre>
./test.sh > results/test-1-1-apache-nginx-home-sampledata.html
./test.sh > results/test-1-2-apache-nginx-home-sampledata.html
./test.sh > results/test-1-3-apache-nginx-home-sampledata.html
</pre>

<h4>category page</h4>
<pre>
./test.sh women/tops-women/jackets-women.html > results/test-2-1-apache-nginx-women-tops-women-jackets-women.html
./test.sh women/tops-women/jackets-women.html > results/test-2-2-apache-nginx-women-tops-women-jackets-women.html
./test.sh women/tops-women/jackets-women.html > results/test-2-3-apache-nginx-women-tops-women-jackets-women.html
</pre>

<h4>product page</h4>
<pre>
./test.sh adrienne-trek-jacket.html > results/test-3-1-product-page.html
./test.sh adrienne-trek-jacket.html > results/test-3-2-product-page.html
./test.sh adrienne-trek-jacket.html > results/test-3-3-product-page.html
</pre>

<h4>add to cart</h4>
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

<pre>
./test.sh checkout/cart/add/product/6/qty/1 > results/test-4-1-add-product-to-cart.html
./test.sh checkout/cart/add/product/6/qty/1 > results/test-4-2-add-product-to-cart.html
./test-add-product-to-cart-edge.sh  > results/test-4-3-add-product-to-cart.html
</pre>


