# SELKS

## Architecture

> Proposition d'architure "simple", à vous de l'adapter en fonction de vos besoins.

* Un serveur Proxmox et ses interfaces (vmbr0, 1, 2, ...)
* Un VM SELKS (192.168.100.100 dans notre exemple)

Dans notre exemple on va envoyer une copie des paquets qui passent par les interfaces du Proxmox vers le SELKS. Dans une infra plus complexe on pourrait imaginer des copies depuis plus de serveurs.

### Mise en place

### Proxmox

```
iptables -t mangle -A PREROUTING -i vmbr0 -j TEE --gateway 192.168.100.100
iptables -t mangle -A PREROUTING -i vmbr1 -j TEE --gateway 192.168.100.100
iptables -t mangle -A PREROUTING -i vmbr2 -j TEE --gateway 192.168.100.100
```

A adapter en fonction de vos interfaces

### SELKS

* Télécharger l'ISO [ici](https://www.stamus-networks.com/selks) (without desktop) et l'installer
* Comptes par défaut
  * `selks-user` / `selks-user`
  * `root` / `StamusNetworks`
* Après l'installation il faudra faire `selks-first-time-setup_stamus`
* On s'assurera que Nginx n'est pas bindé sur localhost, par défaut c'est le cas pour le port 80 mais pas 443 donc ça ne devrait pas poser de problème pour l'accès à l'interface web
* Vérifier que les indexes sont présents et qu'il y a de la donnée qui rentre `curl -s 'localhost:9200/_cat/indices'`
