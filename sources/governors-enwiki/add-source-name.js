const fs = require('fs');
let rawmeta = fs.readFileSync('meta.json');
let meta = JSON.parse(rawmeta);

module.exports = (guid, name) => ({
    guid,
    snaks: {
      P4656: meta.source,
      P813:  new Date().toISOString().split('T')[0],
      P1810: name, // named as (Person)
    }
})
