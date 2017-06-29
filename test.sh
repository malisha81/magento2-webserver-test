#!/bin/bash


RIGHT_NOW=$(date +"%x %r %Z")

source test.cfg

APACHE_TEST_URL="http://$apache/$1"
NGINX_TEST_URL="http://$nginx/$1" 

WAIT_TIMEOUT=120




echo "<!DOCTYPE html><html><body>"
echo "<style type='text/css'>table { text-align:left; } </style>"

echo "<h1>Test  ${RIGHT_NOW}</h1>"
echo "<h2>Apache Url ${APACHE_TEST_URL}</h2>"
echo "<h2>Ngnix Url ${NGINX_TEST_URL}</h2>"


echo "<table>"
echo "<tr>"
echo "<td>No.</td>"
echo "<td>Apache Test</td>"
echo "<td>Nginx Test</td>"
echo "</tr>"


# TEST 1  c5 n50
echo "<tr>"
echo "<td>Users: 5<br />Requests: 50</td>"
echo "<td>"
ab -rwk -s${WAIT_TIMEOUT} -n50 -c5 ${APACHE_TEST_URL}
echo "</td>"
echo "<td>"
ab -rwk -s${WAIT_TIMEOUT} -n50 -c5 ${NGINX_TEST_URL}
echo "</td>"
echo "</tr>"

# TEST 2  c10 n100
echo "<tr>"
echo "<td>Users: 10<br />Requests: 100</td>"
echo "<td>"
ab -rwk -s${WAIT_TIMEOUT} -n100 -c10 ${APACHE_TEST_URL}
echo "</td>"
echo "<td>"
ab -rwk -s${WAIT_TIMEOUT} -n100 -c10 ${NGINX_TEST_URL}
echo "</td>"
echo "</tr>"


# TEST 3  c25 n250
echo "<tr>"
echo "<td>Users: 10<br />Requests: 100</td>"
echo "<td>"
ab -rwk -s${WAIT_TIMEOUT} -n250 -c25 ${APACHE_TEST_URL}
echo "</td>"
echo "<td>"
ab -rwk -s${WAIT_TIMEOUT} -n250 -c25 ${NGINX_TEST_URL}
echo "</td>"
echo "</tr>"


# TEST 4  c50 n500
echo "<tr>"
echo "<td>Users: 10<br />Requests: 100</td>"
echo "<td>"
ab -rwk -s${WAIT_TIMEOUT} -n500 -c50 ${APACHE_TEST_URL}
echo "</td>"
echo "<td>"
ab -rwk -s${WAIT_TIMEOUT} -n500 -c50 ${NGINX_TEST_URL}
echo "</td>"
echo "</tr>"


# TEST 5  c100 n1000
echo "<tr>"
echo "<td>Users: 10<br />Requests: 100</td>"
echo "<td>"
ab -rwk -s${WAIT_TIMEOUT} -n1000 -c100 ${APACHE_TEST_URL}
echo "</td>"
echo "<td>"
ab -rwk -s${WAIT_TIMEOUT} -n1000 -c100 ${NGINX_TEST_URL}
echo "</td>"
echo "</tr>"

echo "</table>"


echo "</body></html>"

