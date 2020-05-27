load("@rules_jvm_external//:defs.bzl", "maven_install")

def avro_repositories():
  maven_install(
    name = "rules_avro_maven",
    artifacts = [
      # for code compilation
      "org.apache.avro:avro:1.8.2",
      # for code generation
      "org.apache.avro:avro-tools:1.8.2",
    ],
    repositories = [
      "https://repo1.maven.org/maven2/",
    ],
  )