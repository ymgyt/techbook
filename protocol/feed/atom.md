# ATOM

* 2つのformatがある
  * The Atom Syndication Format
    * 配信用
  * The Atom Publishing Protocol
    * 編集用

* IETFが管理
* [RFC 4287](https://datatracker.ietf.org/doc/html/rfc4287)
  * [日本語対訳](https://tex2e.github.io/rfc-translater/html/rfc4287.html)

## Format

```xml
<?xml version="1.0" encoding="utf-8"?>
<feed xmlns="http://www.w3.org/2005/Atom">
    
 <title>Example Feed</title>
 <link href="http://example.org/"/>
 <updated>2003-12-13T18:30:02Z</updated>
 <author>
   <name>John Doe</name>
 </author>
 <id>urn:uuid:60a76c80-d399-11d9-b93C-0003939e0af6</id>
    

 <entry>
   <title>Atom-Powered Robots Run Amok</title>
   <link href="http://example.org/2003/12/13/atom03"/>
   <id>urn:uuid:1225c695-cfb8-4ebb-aaaa-80da344efa6a</id>
   <updated>2003-12-13T18:30:02Z</updated>
   <summary>Some text.</summary>
 </entry>

</feed>
```
