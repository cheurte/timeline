mod bridge_generated; /* AUTO INJECTED BY flutter_rust_bridge. This line may not be accurate, and you can change it according to your needs. */
mod api;
#[cfg(test)]
mod test {
    use crate::api::{hello_world, add_sample, send_unmarked_samples};

    #[test]
    fn it_works(){
        hello_world();
    }
    #[test]
    fn test_insert(){
        add_sample(String::from("test"), String::from("test"));
    }
    #[test]
    fn test_read_db(){
        send_unmarked_samples();
    }
}