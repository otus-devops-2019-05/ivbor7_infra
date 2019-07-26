{
"_meta": {
"hostvars": {
  "appserver" : {
    "ansible_host": ${APP_IP}
  },
  "dbserver" : {
    "ansible_host": ${DB_IP}
  }
}
},
  "app": {
    "hosts": ["appserver"]
  },
  "db": {
    "hosts": ["dbserver"]
  }
}
