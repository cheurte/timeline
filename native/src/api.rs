use odbc_api::{Environment, ConnectionOptions, IntoParameter, Cursor, buffers::{ColumnarAnyBuffer, BufferDesc}};
use ascii_converter::*;
const CONNECTION_STRING: &str = "DRIVER=cubeSQL ODBC;\
                                    Server=192.168.7.53;\
                                    uid=corentin;\
                                    pwd=Biotec1234!;\
                                    Database=QS_Data;\
                                    port=4430";

const BATCH_SIZE:usize= 5000;

fn execute_add_sample(date: &str, line: &str) -> Result<(), Box<dyn std::error::Error>>{
    let environment = Environment::new()?;
    let connection = environment
        .connect_with_connection_string(
            CONNECTION_STRING,
            ConnectionOptions::default()
        )?;
    let query= "INSERT INTO pred2 (State, Date, Line, L, a, b, YI) VALUES (0, ?, ?, 0.0, 0.0, 0.0, 0.0)";

    let param = (&date.into_parameter(), &line.into_parameter());
    connection.execute(query, param,)?;
    connection.commit()?;

    Ok(()) 
}

pub fn add_sample(date: String, line: String)->String{
    match execute_add_sample(&date, &line){
        Ok(_)=> String::from("Done"),
        Err(err) => format!("{:?}", err)
    }
}

fn read_unmarked_samples()->Result<Vec<String>, Box<dyn std::error::Error>>{
    let mut row: Vec<String> = Vec::new();
    let mut out: Vec<String> = Vec::new();
    let environment = Environment::new()?;
    let connection = environment
        .connect_with_connection_string(
            CONNECTION_STRING,
            ConnectionOptions::default()
        )?;
    let bd = [
        BufferDesc::Text { max_str_len: 255 },
        BufferDesc::Text { max_str_len: 255 },
        BufferDesc::Text { max_str_len: 255 },
        BufferDesc::Text { max_str_len: 255 },
        BufferDesc::Text { max_str_len: 255 },
        BufferDesc::Text { max_str_len: 255 }
    ];
    let query= "SELECT Date, Line, L, a, b, YI FROM pred2 WHERE State = 0";

    if let Some(cursor) = connection.execute(query, ())?{

        let mut buffer = ColumnarAnyBuffer::from_descs(BATCH_SIZE, bd); 
        let mut row_set_cursor = cursor.bind_buffer(&mut buffer)?;
        
        while let Some(row_set) = row_set_cursor.fetch()? {
            for num_row in 0..row_set.num_rows(){
                for num_cols in 0..row_set.num_cols(){
                    row.push(decimals_to_string(&row_set
                            .column(num_cols)
                            .as_text_view()
                            .ok_or("err")?
                            .get(num_row)
                            .ok_or("err2")?
                            .to_vec())?);
                }
                out.push(row.join(";"));
                row.clear();
            }
        }
    }
    Ok(out)
}

pub fn send_unmarked_samples()->Vec<String>{
    return match read_unmarked_samples() {
        Ok(list) => list,
        Err(e) => vec![format!("{:?}", e)]
    }
}
//     let mut buffer = ColumnarAnyBuffer::from_descs(batch_size, buffer_description);
//     let mut output= String::new();
//     if let Some(cursor) = connection.execute("SELECT Stamp FROM AnlagenDaten LIMIT 1", ())?{

//         let mut row_set_cursor = cursor.bind_buffer(&mut buffer)?;
//         // Loop over row sets
//         while let Some(row_set) = row_set_cursor.fetch()? {
//             // Process names in row set
//             let name_col = row_set.column(0);
//             for name in name_col
//                 .as_text_view()
//                 .expect("Name column buffer expected to be text")
//                 .iter()
//             {
//                 println!("{}",decimals_to_string(&name.ok_or("err")?.to_vec())?);
//                 output = name.ok_or("err")?.first().ok_or("err")?.to_string();
//             }
//         }
//     }
//    Ok(output) 
// } 

pub fn hello_world()-> String{
    return String::from("Hello world");
}