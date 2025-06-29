# Project

This TFG has developed an innovative toolset to support agile and safe database evolution, addressing current needs in continuous software delivery and adaptive systems. Traditional database systems often lack flexibility when adapting to evolving application requirements. Our approach enables systematic and controlled schema changes across a range of database technologies, both relational and NoSQL.
     At the core of the solution is U-Schema, a unified metamodel that abstracts and represents database schemas independently of the underlying technology. Based on this model, we have designed two domain-specific languages: Athena for schema definition, and Orion for expressing evolution scripts through a formal taxonomy of schema changes. This taxonomy is one of the project’s main theoretical contributions and has been designed to be independent of any specific data model, making it applicable across diverse database paradigms.
     The tools support schema versioning and automated migration, generating native scripts for widely used database systems such as MongoDB, Cassandra, Neo4j, and MySQL. While automatic rollback is not implemented, the system maintains a complete history of evolution scripts, enabling the recreation of any past schema version when needed.
     Additionally, we have developed mechanisms for static code analysis (based on CodeQL) that detect application code fragments potentially affected by schema changes—such as JPQL queries or JPA annotations—and report issues using standard formats. These analyses are integrated in CI/CD pipelines through GitHub Actions, helping teams detect and address potential failures early in the development process.
     The approach has been validated through real-world datasets and case studies, resulting in international publications, open-source prototypes, and academic contributions. Overall, the project advances the capabilities available for database evolution in modern application development environments.
     Recently, we have also started to explore the use of Large Language Models (LLMs) to assist in the generation of Athena schemas and Orion evolution scripts from natural language descriptions, opening new opportunities for future research and tooling.

# Estructure 

- 📁 **.github**
  - 📁 codeql
    - 📄 codeql-config.yml
  - 📁 workflows
    - 📄 codeql-analysis.yml
    - 📄 migration-schema.yml
    - 📄 upload-sarif.yml
- 📁 **orion**
  - 📁 orion_scripts
    - V0_description.orion
  - 📄 version_table.md
  - 📄 orion_schema_version.txt
- 📁 **Tools**
  - 📁 es.um.uschema.xtext.athena.parent
  - 📁 es.um.uschema.xtext.orion.parent
  - 📁 spring.data.jpa.codeq.generator
  - 📁 uschema

# Main Components

1. **Continuous Integration** (`.github/workflows/`)  
   - `migration-schema.yml`: version table management
   - `codeql-analysis.yml`: AST Java Generator and CodeQL Inicializer  
   - `upload-sarif.yml`: Upload SARIF results to code-scanning

2. **Migraciones Orion** (`orion/`)  
   - `orion_scripts/`: Migration scripts with name `V{n}_{descripción}.orion`  
   - `orion_schema_version.txt`: check the last version used
   - `version_table.md`: versions table similar to Flyway

3. **Herramientas M2T** (`tools/`)  
   - **Athena & Orion** (Xtext): DSLs para esquema prescriptivo y operaciones  
   - **CodeQL Generator**: convierte Orion → JPQL/@Query anotadas → consultas CodeQL  
   - **U-Schema**: metamodelo unificado relacional/NoSQL  

4. **Caso de uso** (`UseCase/`)  
   - Example app in Java/Spring Boot with Spring Data JPA

# How execute tool M2T to MySQL

1. The modeling tools package must be installed from the official Eclipse website: [Modeling Tools](https://www.eclipse.org/downloads/packages/release/2024-12/r/eclipse-modeling-tools) 

2. Una vez instalado, se deben instalar las siguientes dependencias desde eclipse marketplace:
   - [Xtext](https://marketplace.eclipse.org/content/xtext)
   - [maven2ecore](https://download.eclipse.org/technology/m2e/releases/2.8.0) Esta versión se debe instalar desde install new software, ya que no está disponible en el marketplace.

3. Once installed, the following dependencies must be installed from the Eclipse Marketplace:
   - `es.um.uschema.xtext.orion.parent` 
   - `es.um.uschema.xtext.athena.parent`
   - `uschema`

4. Once imported, for the Athena and Orion Xtext projects, access the package with the same name as the project and run the **Generate(Athena|Orion).mwe2** file. This step will proceed with errors; the code will be built and the files required for the tool will be generated. Both projects must be compiled, first the Athena project and then the Orion project.

5. Once installed, the input method is located inside the `es.um.uschema.xtext.orion` project:
   - `src/main/java/es/um/uschema/xtext/orion/Orion2MySQLMain.java`

6. The input and output files are specified in the arguments:
   ```java
   val customArgs = newArrayList("-i", "models/sql/Umugram.orion", "-o", "models/sql/code-generated")
   ```

# How execute workflows with Orion 
You need configure the codeql-config.yml to specificate the code to analyze.

1. An orion file must be created and placed in the root of the repository, for example `Umugram.orion`.
   ```txt
   ADD ENTITY User {
      +id: Long,
      name: String,
      !email: String
   }
   ```
2. The file must be uploaded with the commit header showing the same name as the Orion file, for example, `Umugram`. That is:
   ```bash
   git add Umugram.orion
   git commit -m "Umugram.orion"
   git push origin main
   ```
3. Once uploaded, the changes will appear minutes later in the Github > Security > Code Scanning section, where you can see the result of the `codeql-analysis.yml` workflow execution.

4. To make a decision, there are two possible messages after this step. The header must be empty (--allow-empty):
- orion(accept): nombre_fichero.orion, description
- orion(cancel): nombre_fichero.orion

5. Sending cases: 
- Acceptation case. 
   ```bash
   git add Umugram.orion
   git commit --allow-empty "orion(accept): Umugram.orion, descripcion"
   git push origin main
   ```
- Cancel case.
   ```bash
   git add Umugram.orion
   git commit --allow-empty "orion(cancel): Umugram.orion"
   git push origin main
   ```

# Authors

- [@Zerep0](https://www.github.com/Zerep0)



