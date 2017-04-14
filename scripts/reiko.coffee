# note
# CREATE TABLE inventory(id integer primary key, name text not null, expiration_date text not null);

# functions
validate_expiration_date = (expiration_date) ->  # expiration_date format must be 'YYYYMMDD'
  ey = parseInt(expiration_date.substr(0, 4), 10)
  em = parseInt(expiration_date.substr(4, 2), 10)
  ed = parseInt(expiration_date.substr(6, 2), 10)
  edate = new Date(ey, em-1, ed)
  today = new Date()
  diff = edate.getTime()-today.getTime()
  return edate.getFullYear()==ey && edate.getMonth()==em-1 && edate.getDate()==ed && diff>0

# main
module.exports = (robot) ->

  sqlite3 = require "sqlite3"
  db = new sqlite3.Database "./databases/main.sqlite3"

  robot.hear /^へるぷ$/i, (res) ->
    res.send [
                "Commands:",
                "  へるぷ",
                "  りすと",
                "  とうろく [food_name] [expiration_date](YYYYMMDD)",
                "  さくじょ [id]"
              ].join("\n")

  robot.hear /^りすと$/i, (res) ->
    db.all "SELECT * FROM inventory", (err, rows) ->
      if err
        res.send "Failed to check, sorry:bow:"
        throw err
      else
        if rows.length == 0
          res.send "Nothing is found in our refrigerator..."
        else
          inventory = "[id], [food_name], [expiration_date]\n"
          rows.forEach (row) ->
            inventory += "#{row.id}, #{row.name}, #{row.expiration_date}\n"
          res.send "#{inventory.substr(0, inventory.length-1)}"

  robot.hear /^とうろく.*/i, (res) ->
    if query = /^とうろく\s+(.*)\s+([0-9]{8})$/i.exec res.match[0]
      name = query[1]
      expiration_date = query[2]
      if validate_expiration_date expiration_date
        db.run "INSERT INTO inventory (name, expiration_date) VALUES (?, ?)", [name, expiration_date], (err) ->
          if err
            res.send "Failed to register, sorry:bow:"
            throw err
          else
            res.send "Registered your request successfully!!"
      else
        res.send "Is the expiration date correct?"
    else
      res.send "Usage: とうろく food_name expiration_date[YYYYMMDD]"

  robot.hear /^さくじょ.*/i, (res) ->
    if query = /^さくじょ\s+([0-9]+)$/i.exec res.match[0]
      id = query[1]
      db.get "SELECT * FROM inventory WHERE id = ?", [id], (err, row) ->
        if typeof row == "undefined"
          res.send "Could not find id='#{id}'. Please check the inventory again."
        else
          if err
            res.send "Could not check whether the id exists or not, sorry:bow:"
            throw err
          else
            db.run "DELETE FROM inventory WHERE id = ?", [id], (err) ->
              if err
                res.send "Failed to delete, sorry:bow:"
                throw err
              else
                res.send "Deleted {id:#{row.id}, name:#{row.name}, expiration_date:#{row.expiration_date}} successfully!!"
    else
      res.send "Usage: さくじょ id"
