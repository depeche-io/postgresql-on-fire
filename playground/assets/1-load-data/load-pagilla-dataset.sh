createdb pagilla

curl https://raw.githubusercontent.com/devrimgunduz/pagila/refs/heads/master/pagila-schema.sql | psql pagilla
curl https://raw.githubusercontent.com/devrimgunduz/pagila/refs/heads/master/pagila-data.sql | psql pagilla
