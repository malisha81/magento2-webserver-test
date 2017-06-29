#!/bin/bash


echo "<!DOCTYPE html><html><body>"
echo "<style type='text/css'>table { text-align:left; } </style>"

echo "<table>"
echo "<tr>"
echo "<td>No.</td>"
echo "<td>Apache Test</td>"
echo "<td>Nginx Test</td>"
echo "</tr>"

# TEST 0  c5 n50
echo "<tr>"
echo "<td>Users: 30<br />Requests: 3000</td>"
echo "<td>"
ab -rwk -s120 -n3000 -c30 http://vps416841.ovh.net/checkout/cart/add/product/6/qty/1
echo "</td>"
echo "<td>"
ab -rwk -s120 -n3000 -c30 http://vps416842.ovh.net/checkout/cart/add/product/6/qty/1
echo "</td>"
echo "</tr>"



echo "</table>"


echo "</body></html>"

