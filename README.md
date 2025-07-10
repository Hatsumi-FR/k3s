# Correction TP K3s — Application Web + API + PostgreSQL

## Structure

Ce projet contient une application décomposée en 3 services :
- `postgres`: base de données avec stockage persistant
- `api`: API connectée à PostgreSQL (ex. Flask ou Node.js)
- `front`: serveur NGINX qui appelle l’API

## Déroulé

1. Un namespace `app-demo` est créé pour isoler l’environnement.
2. Un Secret Kubernetes protège le mot de passe PostgreSQL.
3. Un PVC permet de sauvegarder les données PostgreSQL.
4. Chaque service a son `Deployment` et son `Service` de type `ClusterIP`.
5. Un `Ingress` (via Traefik) permet d’accéder :
   - à l’interface web via `/`
   - à l’API via `/api`

## Test

- Lancez tous les fichiers dans l’ordre croissant.
- Visitez l’adresse IP publique du VPS : vous devriez voir le front.
- Utilisez les outils dev pour vérifier les appels AJAX vers `/api`.

