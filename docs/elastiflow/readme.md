# Elastiflow

> ElastiFlow™ provides network flow data collection and visualization using the Elastic Stack (Elasticsearch, Logstash and Kibana). It supports Netflow v5/v9, sFlow and IPFIX flow types (1.x versions support only Netflow v5/v9).

Sur la page du projet [Github](https://github.com/robcowart/elastiflow) on peut lire "now deprecated ([try the new solution](https://github.com/robcowart/elastiflow))", nouvelle solution payante. Le projet Github est encore fonctionnel et fait largement l'affaire pour un lab étudiant.

## Architecture

> Proposition d'architure "simple", à vous de l'adapter en fonction de vos besoins.

![elastiflow_schema](./elastiflow_schema.png)

Dans cet exemple le serveur Linux va exporter les informations de ses flux réseaux vers l'instance Elastiflow. Cet export est réalisé via [softflowd](https://github.com/irino/softflowd).

## Installation

### Elastiflow

Testé et validé sur une machine Ubuntu 20.04 avec les versions suivantes :

| Outil | Version |
| ----- | ----- |
| Elasticsearch | 7.13 |
| Kibana | 7.13 |
| Logstash | 7.13 |
| Elastiflow | 4.0.1 |

La procédure d'installation sur le Github du projet est claire et détaillée mais pour simplifier les choses et automatiser les installations nous avons un script qui va faire une grande partie du travail à notre place :

```
curl https://raw.githubusercontent.com/simplonco/tssr-cyber-doc/main/docs/elastiflow/elastiflow.sh | bash -
```

### Serveur Linux

Il existe sûrement d'autres solutions mais dans notre cas nous utilisons `softflowd` pour l'export vers Elastiflow. Installer softflowd : `apt-get install softflowd`

En phase de test / expérimentation vous pouvez utiliser une commande comme :

```/usr/sbin/softflowd -i vmbr0 -P udp -d -D -n 192.168.200.101:2055```

Explications :

* `-i` : spécifier l'interface sur laquelle on va écouter (`any` pour toutes les interfaces), seulement vmbr0 dans notre exemple
* `-P` : tcp ou udp
* `-d` : ne pas faire tourner en arrière plan
* `-D` : mode debug
* `-n` : où réaliser l'export (`host:port`), 192.168.200.101 sur le port 2055 dans notre exemple

Vous devriez voir quelque chose comme :

```
/usr/sbin/softflowd -i any -P udp -d -D -n 192.168.200.101:2055
softflowd v0.9.9 starting data collection
Exporting flows to [192.168.200.101]:2055
ADD FLOW seq:1 [5.39.74.133]:22 <> [51.210.251.129]:50530 proto:6
ADD FLOW seq:2 [5.39.74.133]:22 <> [111.198.48.204]:45714 proto:6
ADD FLOW seq:3 [5.39.74.133]:22 <> [125.124.215.222]:55386 proto:6
ADD FLOW seq:4 [fe80::6eb2:aeff:fe60:82c7]:2029 <> [ff02::66]:2029 proto:17
[ .... ]
Starting expiry scan: mode 0
Queuing flow seq:22 (0x55dba9053ff0) for expiry reason 2
Queuing flow seq:24 (0x55dba9053eb0) for expiry reason 2
Queuing flow seq:25 (0x55dba9053e10) for expiry reason 2
Queuing flow seq:29 (0x55dba9053b90) for expiry reason 2
Queuing flow seq:31 (0x55dba9053a50) for expiry reason 2
Queuing flow seq:34 (0x55dba9055990) for expiry reason 2
Finished scan 6 flow(s) to be evicted
Sending v5 flow packet len = 600
sent 1 netflow packets
```

Après validation des options à utiliser il n'y a plus qu'à les reporter dans le fichier de configuration `/etc/softflowd/default.conf`

```
interface='any'
options='-P udp -n host:port'
```

Et démarrer le service

```
systemctl enable --now softflowd
systemctl start softflowd
systemctl status softflowd
```


