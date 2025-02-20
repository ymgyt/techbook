# Parquet Schema

* root は message
* field には3つのattribute
  * repetition
    * required: exact one
    * optional: 0 or 1
    * repeated: 0 to N
  * type
    * primitive
    * group
  * name


```parquet
message AddressBook {
  required string owner;
  repeated string ownerPhoneNumbers;
  repeated group contacts {
    required string name;
    optional string phoneNumber;
  }
}
```
