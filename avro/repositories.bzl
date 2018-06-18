def avro_repositories():
  # for code generation
  native.maven_jar(
      name = "org_apache_avro_avro_tools",
      artifact = "org.apache.avro:avro-tools:1.8.2",
      sha1 = "3d7fc385972dc488d80281d68ccbf5396ec1f9ed",
  )
  native.bind(
      name = 'io_bazel_rules_avro/dependency/avro_tools',
      actual = '@org_apache_avro_avro_tools//jar',
  )

  # for code compilation
  native.maven_jar(
      name = "org_apache_avro_avro",
      artifact = "org.apache.avro:avro:1.8.2",
      sha1 = "91e3146dfff4bd510181032c8276a3a0130c0697",
  )
  native.bind(
      name = 'io_bazel_rules_avro/dependency/avro',
      actual = '@org_apache_avro_avro//jar',
  )
  native.maven_jar(
      name = "joda_time",
      artifact = "joda-time:joda-time:2.10",
  )
  native.bind(
      name = 'io_bazel_rules_avro/dependency/joda_time',
      actual = '@joda_time//jar',
  )
  native.maven_jar(
      name = "org_codehaus_jackson_jackson_core_asl",
      artifact = "org.codehaus.jackson:jackson-core-asl:1.9.13",
  )
  native.bind(
      name = 'io_bazel_rules_avro/dependency/jackson_core_asl',
      actual = '@org_codehaus_jackson_jackson_core_asl//jar',
  )
  native.maven_jar(
      name = "org_codehaus_jackson_jackson_mapper_asl",
      artifact = "org.codehaus.jackson:jackson-mapper-asl:1.9.13",
  )
  native.bind(
      name = 'io_bazel_rules_avro/dependency/jackson_mapper_asl',
      actual = '@org_codehaus_jackson_jackson_mapper_asl//jar',
  )
