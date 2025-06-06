package es.um.uschema.xtext.orion.utils.config

import java.nio.file.Path
import java.util.Properties
import org.apache.commons.cli.Options
import org.apache.commons.cli.HelpFormatter;
import org.apache.commons.cli.Option;
import org.apache.commons.cli.OptionGroup;
import org.apache.commons.cli.DefaultParser
import org.apache.commons.cli.ParseException
import es.um.uschema.xtext.orion.utils.config.defaults.DefaultConfig

class Orion2MongoDBConfig
{
  Path inputModel
  Path inputPath
  Path outputPath
  Boolean transactions
  Properties defaultProperties

  new()
  {
    this.defaultProperties = DefaultConfig.getDefaultConfig()
    this.inputModel = null
    this.inputPath = null
    this.transactions = Boolean.parseBoolean(defaultProperties.getProperty("mongodb_transactions"))
    this.outputPath = Path.of(defaultProperties.getProperty("folder_orion2mongodb"))
  }

  new(String[] args)
  {

    val options = new Options()

    options.addOption(Option.builder("h").longOpt("help").desc("Prints help").build())
    options.addOption(Option.builder("o").longOpt("output").desc("Path to an output folder").hasArg().argName("output_folder").build())
    options.addOption(Option.builder("t").longOpt("transactions").desc("Enable transaction generation").required(false).build())

    val inputMode = new OptionGroup();
    inputMode.setRequired(true);
    inputMode.addOption(Option.builder("i").longOpt("input").desc("Path to an input model").hasArg().argName("model").build())
    inputMode.addOption(Option.builder("f").longOpt("folder").desc("Path to an input folder").hasArg().argName("input_folder").build())
    options.addOptionGroup(inputMode)

    val parser = new DefaultParser()
    val formatter = new HelpFormatter()

    try
    {
      val cmd = parser.parse(options, args)

      if (cmd.hasOption("h"))
      {
        formatter.printHelp("<Orion2MongoDB Main>", options)
        System.exit(0)
      }

      if (cmd.hasOption("i"))
        this.inputModel = Path.of(cmd.getOptionValue("i"))

      if (cmd.hasOption("f"))
        this.inputPath = Path.of(cmd.getOptionValue("f"))

      if (cmd.hasOption("t"))
        this.transactions = true

      if (cmd.hasOption("o"))
        this.outputPath = Path.of(cmd.getOptionValue("o"))
    } catch (ParseException e)
    {
      System.out.println(e.getMessage());
      formatter.printHelp("<Orion2MongoDB Main>", options);

      System.exit(1);
    }
  }

  def void setInputModel(Path inputModel)
  {
    this.inputModel = inputModel
  }

  def Path getInputModel()
  {
    return this.inputModel
  }

  def void setInputPath(Path inputPath)
  {
    this.inputPath = inputPath
  }

  def Path getInputPath()
  {
    return this.inputPath
  }

  def void setTransactions(Boolean transactions)
  {
    this.transactions = transactions
  }

  def Boolean getTransactions()
  {
    return this.transactions
  }

  def void setOutputPath(Path outputPath)
  {
    this.outputPath = outputPath
  }

  def Path getOutputPath()
  {
    return this.outputPath
  }
}
