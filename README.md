# Tossing
A decision-make helper

#### Description:
You can use this app to create many "lists" which each list contains several choices, 
this app will return you one choice randomly to help you make the decision, 
just like tossing a coin.

#####For example: 
You can create a list called "what to eat", and in the list you add "pizza", "steak" and "MacDonald",
it will randomly return you an item to help you decide what to eat for the meal. 

And you have another list called "working schedual", then you add "prepare for cs exam", "writing the paper",
"nap for 10 min" and "play basketball to relax", it can help you make a schedual what to do next, but randomly!

## Technical Specs

### Database 
#### Sqlite by FMDB
Use sqlite as database and operate by an implementation of FMDB:
<pre><code>private func initDB(){
        let defaultManager = NSFileManager.defaultManager()
        dbFilePath = defaultManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!.URLByAppendingPathComponent("tosse.db").path!
        print(dbFilePath)
        
        let dbListCreateStatements = "CREATE TABLE IF NOT EXISTS LISTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, TITLE TEXT, STAR BOOL)";
        let dbItemCreateStatements = "CREATE TABLE IF NOT EXISTS ITEMS (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, HOST TEXT)";
        
        
        let personDB = FMDatabase(path: dbFilePath)
        
        if personDB == nil{
            print("Error:\(personDB.lastErrorMessage())")
        }else{
            if personDB.open(){
                if !personDB.executeStatements(dbListCreateStatements){
                    print("Error:\(personDB.lastErrorMessage())")
                }
                if !personDB.executeStatements(dbItemCreateStatements){
                    print("Error:\(personDB.lastErrorMessage())")
                }
            }
            personDB.close()
        }
    }
</code></pre>

<pre></code>
        let db = FMDatabase(path: dbFilePath)
        guard db.open() 
        else {
            print("Error:\(db.lastErrorMessage())")
            return
        }
                
        let list = label_new.text
                
        for item in items{
            let insertPersonStatement = "INSERT INTO ITEMS (NAME,HOST) VALUES (?,?)"
            do{
                try db.executeUpdate(insertPersonStatement, values: [item,list ?? NSNull()])
            }catch{
                print("Error:\(error)")
            }
        }
        
        let insertPersonStatement = "INSERT INTO LISTS (TITLE, STAR) VALUES (?,?)"
        do{
            try db.executeUpdate(insertPersonStatement, values: [list!, false ?? NSNull()])
            db.close()
        }catch{
            db.close()
            print("Error:\(error)")
        }
</code></pre>
