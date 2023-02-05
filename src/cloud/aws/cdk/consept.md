# CDK Concepts

## Physical Name

* 実際に作成されるResourceの名前のこと
* `<resourceType>Name`のpropertyで指定もできる
* **あるpropertyの変更がresourceのcreate deleteを引き起こす場合、指定してあると失敗する**

```typescript
const bucket = new s3.Bucket(this, 'MyBucket', {
  bucketName: 'my-bucket-name',
});
```

