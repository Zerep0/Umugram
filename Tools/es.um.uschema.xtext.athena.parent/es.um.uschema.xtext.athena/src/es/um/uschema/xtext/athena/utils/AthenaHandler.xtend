package es.um.uschema.xtext.athena.utils

import es.um.uschema.xtext.athena.athena.Feature
import es.um.uschema.xtext.athena.athena.ShortEntityDecl
import es.um.uschema.xtext.athena.athena.StructureLiteral
import es.um.uschema.xtext.athena.athena.RegularEntityDecl
import es.um.uschema.xtext.athena.athena.SimpleFeature
import es.um.uschema.xtext.athena.athena.ShortRelationshipDecl
import es.um.uschema.xtext.athena.athena.RegularRelationshipDecl
import es.um.uschema.xtext.athena.athena.VariationDecl
import org.eclipse.emf.common.util.EList
import java.util.ArrayList
import org.eclipse.emf.common.util.BasicEList
import es.um.uschema.xtext.athena.athena.SchemaTypeDecl
import org.eclipse.emf.ecore.EObject
import es.um.uschema.xtext.athena.athena.EntityDecl
import java.util.List
import es.um.uschema.xtext.athena.athena.ComposedReference
import es.um.uschema.xtext.athena.athena.AthenaSchema
import org.eclipse.xtext.EcoreUtil2
import es.um.uschema.xtext.athena.athena.SimpleReferenceTarget
import es.um.uschema.xtext.athena.athena.SimpleAggregateTarget
import es.um.uschema.xtext.athena.athena.Type
import es.um.uschema.xtext.athena.athena.PrimitiveType
import es.um.uschema.xtext.athena.athena.SinglePrimitiveType
import es.um.uschema.xtext.athena.athena.RelationshipDecl
import java.util.Arrays
import es.um.uschema.xtext.athena.athena.DataType

class AthenaHandler
{
  val factory = new AthenaFactory

  def dispatch void addFeatureToSchemaType(ShortEntityDecl entity, Feature feature)
  {
    if (entity.structure === null)
      entity.structure = factory.createStructureLiteral(factory.createFeatureSet)

    addFeatureToStruct(entity.structure as StructureLiteral, feature)
  }

  def dispatch void addFeatureToSchemaType(RegularEntityDecl entity, Feature feature)
  {
    if (feature instanceof SimpleFeature && (feature as SimpleFeature).isOptional)
      throw new IllegalArgumentException("Cannot add an optional feature to a regular Entity")

    if (entity.common === null)
      entity.common = factory.createCommonSpec(factory.createStructureLiteral(factory.createFeatureSet))

    addFeatureToStruct(entity.common.structure as StructureLiteral, feature)
  }

  def dispatch void addFeatureToSchemaType(ShortRelationshipDecl relationship, Feature feature)
  {
    if (relationship.structure === null)
      relationship.structure = factory.createStructureLiteral(factory.createFeatureSet)

    addFeatureToStruct(relationship.structure as StructureLiteral, feature)
  }

  def dispatch void addFeatureToSchemaType(RegularRelationshipDecl relationship, Feature feature)
  {
    if (feature instanceof SimpleFeature && (feature as SimpleFeature).isOptional)
      throw new IllegalArgumentException("Cannot add an optional feature to a regular Relationship")

    if (relationship.common === null)
      relationship.common = factory.createCommonSpec(factory.createStructureLiteral(factory.createFeatureSet))

    addFeatureToStruct(relationship.common.structure as StructureLiteral, feature)
  }

  def void addFeatureToVariation(VariationDecl variation, Feature feature)
  {
    if (feature instanceof SimpleFeature && (feature as SimpleFeature).isOptional)
      throw new IllegalArgumentException("Cannot add an optional feature to a Variation")

    if (variation.structure === null)
      variation.structure = factory.createStructureLiteral(factory.createFeatureSet)

    addFeatureToStruct(variation.structure as StructureLiteral, feature)
  }

  private def void addFeatureToStruct(StructureLiteral struct, Feature feature)
  {
    if (feature instanceof ComposedReference || !getFeaturesInStruct(struct, true).exists[f | f instanceof SimpleFeature && (f as SimpleFeature).name.equals((feature as SimpleFeature).name)])
      (struct as StructureLiteral).spec.features.add(feature)
  }

  def dispatch void addFeaturesAsUnionToSchemaType(ShortEntityDecl entity, List<Feature> features)
  {
    entity.structure = factory.createStructureExpr(entity.structure, factory.createStructureLiteral(factory.createFeatureSet(features)), "U")
  }

  def dispatch void addFeaturesAsUnionToSchemaType(RegularEntityDecl entity, List<Feature> features)
  {
    entity.common.structure = factory.createStructureExpr(entity.common.structure, factory.createStructureLiteral(factory.createFeatureSet(features)), "U")
  }

  def dispatch void addFeaturesAsUnionToSchemaType(ShortRelationshipDecl relationship, List<Feature> features)
  {
    relationship.structure = factory.createStructureExpr(relationship.structure, factory.createStructureLiteral(factory.createFeatureSet(features)), "U")
  }

  def dispatch void addFeaturesAsUnionToSchemaType(RegularRelationshipDecl relationship, List<Feature> features)
  {
    relationship.common.structure = factory.createStructureExpr(relationship.common.structure, factory.createStructureLiteral(factory.createFeatureSet(features)), "U")
  }

  def dispatch List<Feature> getFeaturesInSchemaType(ShortEntityDecl entity)
  {
    if (entity.structure !== null)
      return getFeaturesInStruct(entity.structure as StructureLiteral, true)

    return new BasicEList<Feature>()
  }

  def dispatch List<Feature> getFeaturesInSchemaType(RegularEntityDecl entity)
  {
    if (entity.common !== null)
      return getFeaturesInStruct(entity.common.structure as StructureLiteral, true)

    return new BasicEList<Feature>()
  }

  def dispatch List<Feature> getFeaturesInSchemaType(ShortRelationshipDecl relationship)
  {
    if (relationship.structure !== null)
      return getFeaturesInStruct(relationship.structure as StructureLiteral, true)

    return new BasicEList<Feature>()
  }

  def dispatch List<Feature> getFeaturesInSchemaType(RegularRelationshipDecl relationship)
  {
    if (relationship.common !== null)
      return getFeaturesInStruct(relationship.common.structure as StructureLiteral, true)

    return new BasicEList<Feature>()
  }

  def List<Feature> getFeaturesInVariation(VariationDecl variation)
  {
    if (variation !== null && variation.structure !== null)
      return getFeaturesInStruct(variation.structure as StructureLiteral, true)

    return new BasicEList<Feature>()
  }

  def dispatch List<Feature> getDirectFeaturesInSchemaType(ShortEntityDecl entity)
  {
    if (entity.structure !== null)
      return getFeaturesInStruct(entity.structure as StructureLiteral, false)

    return new BasicEList<Feature>()
  }

  def dispatch List<Feature> getDirectFeaturesInSchemaType(RegularEntityDecl entity)
  {
    if (entity.common !== null)
      return getFeaturesInStruct(entity.common.structure as StructureLiteral, false)

    return new BasicEList<Feature>()
  }

  def dispatch List<Feature> getDirectFeaturesInSchemaType(ShortRelationshipDecl relationship)
  {
    if (relationship.structure !== null)
      return getFeaturesInStruct(relationship.structure as StructureLiteral, false)

    return new BasicEList<Feature>()
  }

  def dispatch List<Feature> getDirectFeaturesInSchemaType(RegularRelationshipDecl relationship)
  {
    if (relationship.common !== null)
      return getFeaturesInStruct(relationship.common.structure as StructureLiteral, false)

    return new BasicEList<Feature>()
  }

  def List<Feature> getDirectFeaturesInVariation(VariationDecl variation)
  {
    if (variation !== null && variation.structure !== null)
      return getFeaturesInStruct(variation.structure as StructureLiteral, false)

    return new BasicEList<Feature>()
  }

  private def List<Feature> getFeaturesInStruct(StructureLiteral struct, boolean copy)
  {
    return struct.spec.features.map[feat | copy ? EcoreUtil2.copy(feat) : feat]
  }

  def dispatch SimpleFeature getSimpleFeatureInSchemaType(ShortEntityDecl schemaType, String name)
  {
    return getFeaturesInSchemaType(schemaType).filter(SimpleFeature).findFirst[f | f.name.equals(name)]
  }

  def dispatch SimpleFeature getSimpleFeatureInSchemaType(ShortRelationshipDecl schemaType, String name)
  {
    return getFeaturesInSchemaType(schemaType).filter(SimpleFeature).findFirst[f | f.name.equals(name)]
  }

  def dispatch SimpleFeature getSimpleFeatureInSchemaType(RegularEntityDecl schemaType, String name)
  {
    return getFeaturesInSchemaTypeAndVariations(schemaType).filter(SimpleFeature).findFirst[f | f.name.equals(name)]
  }

  def dispatch SimpleFeature getSimpleFeatureInSchemaType(RegularRelationshipDecl schemaType, String name)
  {
    return getFeaturesInSchemaTypeAndVariations(schemaType).filter(SimpleFeature).findFirst[f | f.name.equals(name)]
  }

  def SimpleFeature getSimpleFeatureInVariation(VariationDecl variation, String name)
  {
    return getFeaturesInVariation(variation).filter(SimpleFeature).findFirst[f | f.name.equals(name)]
  }

  // The aim is to get, from a List of Variations, the Set of Features made by the Union of the Variation features
  // That means taking a SimpleFeature only if there is not any features with the same name on the resulting list.
  def List<Feature> getReducedFeaturesInVariations(List<VariationDecl> variations)
  {
    val result = new ArrayList<Feature>()

    for (variation : variations)
      for (feat : getFeaturesInVariation(variation))
        if (feat instanceof ComposedReference || !result.exists[f | f instanceof SimpleFeature && (f as SimpleFeature).name.equals((feat as SimpleFeature).name)])
          result.add(feat)

    return result
  }

  def List<Feature> getFeaturesInSchemaTypeAndVariations(SchemaTypeDecl schemaType)
  {
    switch (schemaType)
    {
      case schemaType instanceof RegularEntityDecl:       return (getFeaturesInSchemaType(schemaType)
        + (schemaType as RegularEntityDecl).variations.flatMap[v | getFeaturesInVariation(v)].map[feat | feat instanceof SimpleFeature ? { (feat as SimpleFeature).optional = true; return feat } : feat]).toList
      case schemaType instanceof RegularRelationshipDecl: return (getFeaturesInSchemaType(schemaType)
        + (schemaType as RegularRelationshipDecl).variations.flatMap[v | getFeaturesInVariation(v)].map[feat | feat instanceof SimpleFeature ? { (feat as SimpleFeature).optional = true; return feat } : feat]).toList
      default:                                            return getFeaturesInSchemaType(schemaType)
    }
  }

  def List<Feature> getReducedFeaturesInSchemaTypeAndVariations(SchemaTypeDecl schemaType)
  {
    switch (schemaType)
    {
      case schemaType instanceof RegularEntityDecl:       return (getFeaturesInSchemaType(schemaType)
        + getReducedFeaturesInVariations((schemaType as RegularEntityDecl).variations).map[feat | feat instanceof SimpleFeature ? { (feat as SimpleFeature).optional = true; return feat } : feat]).toList
      case schemaType instanceof RegularRelationshipDecl: return (getFeaturesInSchemaType(schemaType)
        + getReducedFeaturesInVariations((schemaType as RegularRelationshipDecl).variations).map[feat | feat instanceof SimpleFeature ? { (feat as SimpleFeature).optional = true; return feat } : feat]).toList
      default:                                            return getFeaturesInSchemaType(schemaType)
    }
  }

  def List<Feature> getFeaturesInAggregate(EList<EObject> obj)
  {
    if (obj.head instanceof EntityDecl)
      return getFeaturesInSchemaType(obj.head as EntityDecl)
    else
      return (getFeaturesInSchemaType(obj.head.eContainer as EntityDecl)
        + getReducedFeaturesInVariations(obj.map[o | o as VariationDecl]).map[feat | feat instanceof SimpleFeature ? { (feat as SimpleFeature).optional = true; return feat } : feat]).toList
  }

  def SimpleFeature getKeyInSchemaType(SchemaTypeDecl schemaType)
  {
    return getFeaturesInSchemaType(schemaType).filter(SimpleFeature).findFirst[feat | feat.key]
  }
  
  def java.util.List<SimpleFeature> getKeysInSchemaType(SchemaTypeDecl schemaType)
  {
    return getFeaturesInSchemaType(schemaType).filter(SimpleFeature).filter[feat | feat.key].toList
  }

  def dispatch void removeSimpleFeatureInSchemaType(ShortEntityDecl entity, String name)
  {
    if (entity.structure !== null)
      getFeaturesInStruct(entity.structure as StructureLiteral, false).removeIf(f | f instanceof SimpleFeature && (f as SimpleFeature).name.equals(name))
  }

  def dispatch void removeSimpleFeatureInSchemaType(RegularEntityDecl entity, String name)
  {
    for (variation : entity.variations)
      removeSimpleFeatureInVariation(variation, name)

    if (entity.common !== null)
      getFeaturesInStruct(entity.common.structure as StructureLiteral, false).removeIf(f | f instanceof SimpleFeature && (f as SimpleFeature).name.equals(name))
  }

  def dispatch void removeSimpleFeatureInSchemaType(ShortRelationshipDecl relationship, String name)
  {
    if (relationship.structure !== null)
      getFeaturesInStruct(relationship.structure as StructureLiteral, false).removeIf(f | f instanceof SimpleFeature && (f as SimpleFeature).name.equals(name))
  }

  def dispatch void removeSimpleFeatureInSchemaType(RegularRelationshipDecl relationship, String name)
  {
    for (variation : relationship.variations)
      removeSimpleFeatureInVariation(variation, name)

    if (relationship.common !== null)
      getFeaturesInStruct(relationship.common.structure as StructureLiteral, false).removeIf(f | f instanceof SimpleFeature && (f as SimpleFeature).name.equals(name))
  }

  def void removeSimpleFeatureInVariation(VariationDecl variation, String name)
  {
    if (variation.structure !== null)
      getFeaturesInStruct(variation.structure as StructureLiteral, false).removeIf(f | f instanceof SimpleFeature && (f as SimpleFeature).name.equals(name))
  }

  def dispatch void setKeyOfSimpleFeatureInSchemaType(ShortEntityDecl entity, String name, boolean isKey)
  {
    if (entity.structure !== null)
      getFeaturesInStruct(entity.structure as StructureLiteral, false)
        .filter[f | f instanceof SimpleFeature && (f as SimpleFeature).name.equals(name)]
        .forEach[f | (f as SimpleFeature).key = isKey]
  }

  def dispatch void setKeyOfSimpleFeatureInSchemaType(RegularEntityDecl entity, String name, boolean isKey)
  {
    for (variation : entity.variations)
      setKeyOfSimpleFeatureInVariation(variation, name, isKey)

    if (entity.common !== null)
      getFeaturesInStruct(entity.common.structure as StructureLiteral, false)
        .filter[f | f instanceof SimpleFeature && (f as SimpleFeature).name.equals(name)]
        .forEach[f | (f as SimpleFeature).key = isKey]
  }

  def dispatch void setKeyOfSimpleFeatureInSchemaType(ShortRelationshipDecl relationship, String name, boolean isKey)
  {
    if (relationship.structure !== null)
      getFeaturesInStruct(relationship.structure as StructureLiteral, false)
        .filter[f | f instanceof SimpleFeature && (f as SimpleFeature).name.equals(name)]
        .forEach[f | (f as SimpleFeature).key = isKey]
  }

  def dispatch void setKeyOfSimpleFeatureInSchemaType(RegularRelationshipDecl relationship, String name, boolean isKey)
  {
    for (variation : relationship.variations)
      setKeyOfSimpleFeatureInVariation(variation, name, isKey)

    if (relationship.common !== null)
      getFeaturesInStruct(relationship.common.structure as StructureLiteral, false)
        .filter[f | f instanceof SimpleFeature && (f as SimpleFeature).name.equals(name)]
        .forEach[f | (f as SimpleFeature).key = isKey]
  }

  def void setKeyOfSimpleFeatureInVariation(VariationDecl variation, String name, boolean isKey)
  {
    if (variation.structure !== null)
      getFeaturesInStruct(variation.structure as StructureLiteral, false)
        .filter[f | f instanceof SimpleFeature && (f as SimpleFeature).name.equals(name)]
        .forEach[f | (f as SimpleFeature).key = isKey]
  }

  def dispatch void setTypeOfSimpleFeatureInSchemaType(ShortEntityDecl entity, String name, Type newType)
  {
    if (entity.structure !== null)
      setTypeOfSimpleFeatureInStruct(entity.structure as StructureLiteral, name, newType)
  }

  def dispatch void setTypeOfSimpleFeatureInSchemaType(RegularEntityDecl entity, String name, Type newType)
  {
    for (variation : entity.variations)
      setTypeOfSimpleFeatureInVariation(variation, name, newType)

    if (entity.common !== null)
      setTypeOfSimpleFeatureInStruct(entity.common.structure as StructureLiteral, name, newType)
  }

  def dispatch void setTypeOfSimpleFeatureInSchemaType(ShortRelationshipDecl relationship, String name, Type newType)
  {
    if (relationship.structure !== null)
      setTypeOfSimpleFeatureInStruct(relationship.structure as StructureLiteral, name, newType)
  }

  def dispatch void setTypeOfSimpleFeatureInSchemaType(RegularRelationshipDecl relationship, String name, Type newType)
  {
    for (variation : relationship.variations)
      setTypeOfSimpleFeatureInVariation(variation, name, newType)

    if (relationship.common !== null)
      setTypeOfSimpleFeatureInStruct(relationship.common.structure as StructureLiteral, name, newType)
  }

  def void setTypeOfSimpleFeatureInVariation(VariationDecl variation, String name, Type newType)
  {
    if (variation.structure !== null)
      setTypeOfSimpleFeatureInStruct(variation.structure as StructureLiteral, name, newType)
  }

  private def void setTypeOfSimpleFeatureInStruct(StructureLiteral struct, String name, Type newType)
  {
    // If an operation changes a type, we first check the feature. If it is a Reference, then we change the references type.
    // If it was another thing (Aggregate, DataType) we set the new type.
    getFeaturesInStruct(struct, false)
      .filter[f | f instanceof SimpleFeature && (f as SimpleFeature).name.equals(name)]
      .forEach[f | (f as SimpleFeature).type instanceof SimpleReferenceTarget && newType instanceof PrimitiveType ?
        ((f as SimpleFeature).type as SimpleReferenceTarget).type = EcoreUtil2.copy(newType as SinglePrimitiveType)
        :
        (f as SimpleFeature).type = EcoreUtil2.copy(newType)
      ]
  }

  def dispatch void setNameOfSimpleFeatureInSchemaType(ShortEntityDecl entity, String oldName, String newName)
  {
    if (entity.structure !== null)
      setNameOfSimpleFeatureInStruct(entity.structure as StructureLiteral, oldName, newName)
  }

  def dispatch void setNameOfSimpleFeatureInSchemaType(RegularEntityDecl entity, String oldName, String newName)
  {
    for (variation : entity.variations)
      setNameOfSimpleFeatureInVariation(variation, oldName, newName)

    if (entity.common !== null)
      setNameOfSimpleFeatureInStruct(entity.common.structure as StructureLiteral, oldName, newName)
  }

  def dispatch void setNameOfSimpleFeatureInSchemaType(ShortRelationshipDecl relationship, String oldName, String newName)
  {
    if (relationship.structure !== null)
      setNameOfSimpleFeatureInStruct(relationship.structure as StructureLiteral, oldName, newName)
  }

  def dispatch void setNameOfSimpleFeatureInSchemaType(RegularRelationshipDecl relationship, String oldName, String newName)
  {
    for (variation : relationship.variations)
      setNameOfSimpleFeatureInVariation(variation, oldName, newName)

    if (relationship.common !== null)
      setNameOfSimpleFeatureInStruct(relationship.common.structure as StructureLiteral, oldName, newName)
  }

  def void setNameOfSimpleFeatureInVariation(VariationDecl variation, String oldName, String newName)
  {
    if (variation.structure !== null)
      setNameOfSimpleFeatureInStruct(variation.structure as StructureLiteral, oldName, newName)
  }

  private def void setNameOfSimpleFeatureInStruct(StructureLiteral struct, String oldName, String newName)
  {
    getFeaturesInStruct(struct, false)
      .filter[f | f instanceof SimpleFeature && (f as SimpleFeature).name.equals(oldName)]
      .forEach[f | (f as SimpleFeature).name = newName]
  }

  def dispatch void setMultiplicityOfSimpleFeatureInSchemaType(ShortEntityDecl entity, String name, String multiplicity)
  {
    if (entity.structure !== null)
      setMultiplicityOfSimpleFeatureInStruct(entity.structure as StructureLiteral, name, multiplicity)
  }

  def dispatch void setMultiplicityOfSimpleFeatureInSchemaType(RegularEntityDecl entity, String name, String multiplicity)
  {
    for (variation : entity.variations)
      setMultiplicityOfSimpleFeatureInVariation(variation, name, multiplicity)

    if (entity.common !== null)
      setMultiplicityOfSimpleFeatureInStruct(entity.common.structure as StructureLiteral, name, multiplicity)
  }

  def dispatch void setMultiplicityOfSimpleFeatureInSchemaType(ShortRelationshipDecl relationship, String name, String multiplicity)
  {
    if (relationship.structure !== null)
      setMultiplicityOfSimpleFeatureInStruct(relationship.structure as StructureLiteral, name, multiplicity)
  }

  def dispatch void setMultiplicityOfSimpleFeatureInSchemaType(RegularRelationshipDecl relationship, String name, String multiplicity)
  {
    for (variation : relationship.variations)
      setMultiplicityOfSimpleFeatureInVariation(variation, name, multiplicity)

    if (relationship.common !== null)
      setMultiplicityOfSimpleFeatureInStruct(relationship.common.structure as StructureLiteral, name, multiplicity)
  }

  def void setMultiplicityOfSimpleFeatureInVariation(VariationDecl variation, String name, String multiplicity)
  {
    if (variation.structure !== null)
      setMultiplicityOfSimpleFeatureInStruct(variation.structure as StructureLiteral, name, multiplicity)
  }

  private def void setMultiplicityOfSimpleFeatureInStruct(StructureLiteral struct, String name, String multiplicity)
  {
    getFeaturesInStruct(struct, false)
      .filter[f | f instanceof SimpleFeature && (f as SimpleFeature).name.equals(name)]
      .forEach[f |
        val type = (f as SimpleFeature).type
        if (type instanceof SimpleReferenceTarget)
          (type as SimpleReferenceTarget).multiplicity = multiplicity
        else if (type instanceof SimpleAggregateTarget)
          (type as SimpleAggregateTarget).multiplicity = multiplicity
      ]
  }

  def String getSimpleAggregateTargetName(SimpleAggregateTarget aggr)
  {
    aggr.aggr.head instanceof EntityDecl ? (aggr.aggr.head as EntityDecl).name : ((aggr.aggr.head as VariationDecl).eContainer as EntityDecl).name
  }

  def List<SimpleFeature> getReducedSimpleFeaturesIn(SchemaTypeDecl sch1, SchemaTypeDecl sch2)
  {
    val result = new ArrayList<SimpleFeature>()

    result.addAll(getReducedFeaturesInSchemaTypeAndVariations(sch1).filter(SimpleFeature))
    result.addAll(getReducedFeaturesInSchemaTypeAndVariations(sch2).filter(SimpleFeature).filter[feat | !result.stream.map(f | f.name).anyMatch(f | f.equals(feat.name))])

    return result
  }

  def EntityDecl getEntityDecl(AthenaSchema schema, String name)
  {
    return schema.entities.findFirst[e | e.name.equals(name)]
  }

  def RelationshipDecl getRelationshipDecl(AthenaSchema schema, String name)
  {
    return schema.relationships.findFirst[e | e.name.equals(name)]
  }

  def SchemaTypeDecl getSchemaTypeDecl(AthenaSchema schema, String name)
  {
    return (schema.entities + schema.relationships).findFirst[e | e.name.equals(name)]
  }

  def SinglePrimitiveType getMostSuitableType(List<SinglePrimitiveType> options)
  {
    val orderedTypeList = Arrays.asList("string", "identifier", "double", "float", "number", "integer", "int", "timestamp", "boolean", "bool")

    for (t : orderedTypeList) // We iterate over the priority type until we find the most open type possible.
      if (options.exists[innerT | innerT.typename.toLowerCase.equals(t)])
        return options.findFirst[innerT | innerT.typename.toLowerCase.equals(t)]

    return options.head
  }

  def boolean isMultiplicityFromZero(String multiplicity)
  {
    return multiplicity.equals("?") || multiplicity.equals("*")
  }

  def boolean isMultiplicityFromOne(String multiplicity)
  {
    return multiplicity.equals("&") || multiplicity.equals("+")
  }

  def boolean isMultiplicityToOne(String multiplicity)
  {
    return multiplicity.equals("?") || multiplicity.equals("&")
  }

  def boolean isMultiplicityToMany(String multiplicity)
  {
    return multiplicity.equals("*") || multiplicity.equals("+")
  }

  def boolean hasUniqueFeatures(VariationDecl variation)
  {
    if (variation === null || variation.eContainer === null)
      return false

    val varFeatNames = getFeaturesInVariation(variation).filter(SimpleFeature).map[f | f.name]
    val otherFeatNames = this.getVariations(variation.eContainer as SchemaTypeDecl).filter[v | v !== variation].flatMap[v | getFeaturesInVariation(v).filter(SimpleFeature)].map[f | f.name]

    return varFeatNames.exists[f | !otherFeatNames.exists[f2 | f.equals(f2)]]
  }

  def List<SimpleFeature> getUniqueFeaturesInVariation(VariationDecl variation)
  {
    val varFeatures = getFeaturesInVariation(variation).filter(SimpleFeature).toList

    if (variation.eContainer === null)
      return varFeatures

    val otherFeats = this.getVariations(variation.eContainer as SchemaTypeDecl).filter[v | v !== variation].flatMap[v | getFeaturesInVariation(v).filter(SimpleFeature)]

    return varFeatures.filter[f | !otherFeats.exists[f2 | f.name.equals(f2.name)]].toList
  }

  def List<SimpleFeature> getFeaturesNotInVariation(VariationDecl variation)
  {
    if (variation.eContainer === null)
      return new ArrayList

    val varFeatures = getFeaturesInVariation(variation).filter(SimpleFeature).toList
    
    val otherFeats = getReducedFeaturesInVariations(this.getVariations(variation.eContainer as SchemaTypeDecl).filter[v | v !== variation].toList).filter(SimpleFeature)

    return otherFeats.reject[f | varFeatures.exists[f2 | f.name.equals(f2.name)]].toList
  }

  def List<VariationDecl> getVariations(SchemaTypeDecl schemaT)
  {
    if (schemaT instanceof RegularEntityDecl)
      return (schemaT as RegularEntityDecl).variations

    if (schemaT instanceof RegularRelationshipDecl)
      return (schemaT as RegularRelationshipDecl).variations

    return new BasicEList<VariationDecl>()
  }

  def boolean isEntityDecl(AthenaSchema schema, String name)
  {
    return this.getEntityDecl(schema, name) !== null
  }

  def boolean isRelationshipDecl(AthenaSchema schema, String name)
  {
    return this.getRelationshipDecl(schema, name) !== null
  }

  def boolean isSchemaTypeShort(SchemaTypeDecl schemaT)
  {
    return schemaT instanceof ShortEntityDecl || schemaT instanceof ShortRelationshipDecl
  }

  def boolean isSchemaTypeRegular(SchemaTypeDecl schemaT)
  {
    return schemaT instanceof RegularEntityDecl || schemaT instanceof RegularRelationshipDecl
  }

  def List<SimpleFeature> getSimpleFeaturesDifference(List<Feature> featList1, List<Feature> featList2)
  {
    // To get differences between two simple feature lists, we take those simple features that exist on the first feature list, but do not exist on the second list.
    return featList1.filter(SimpleFeature).filter[feat1 | !featList2.filter(SimpleFeature).exists[feat2 | feat1.name.equals(feat2.name)]].toList
  }

  def List<SimpleFeature> getFeaturesInReference(AthenaSchema schema, String relationshipName, List<String> variationIds)
  {
    if (relationshipName === null)
      return new BasicEList<SimpleFeature>()

    val relationship = this.getRelationshipDecl(schema, relationshipName)

    variationIds.empty ?
      this.getReducedFeaturesInSchemaTypeAndVariations(relationship).filter(SimpleFeature).toList
      :
      this.getReducedFeaturesInVariations(this.getVariations(relationship).filter[v | variationIds.contains(v.name)].toList).filter(SimpleFeature).toList
  }

  def dispatch DataType getInnerTypeFromCollection(es.um.uschema.xtext.athena.athena.List collection) { return collection.elementType }
  def dispatch DataType getInnerTypeFromCollection(es.um.uschema.xtext.athena.athena.Set collection)  { return collection.elementType }

  def EntityDecl getAggregatedEntityDecl(SimpleAggregateTarget aggregate)
  {
    return aggregate.aggr.head instanceof EntityDecl ?
      aggregate.aggr.head as EntityDecl
      :
      aggregate.aggr.head.eContainer as EntityDecl
  }

  def List<EntityDecl> getReferencedEntities(EntityDecl entity)
  {
    val result = new ArrayList<EntityDecl>()

    for (ref : this.getFeaturesInSchemaTypeAndVariations(entity).filter(SimpleFeature).filter[f | f.type instanceof SimpleReferenceTarget])
      result.add((ref.type as SimpleReferenceTarget).ref)

    for (aggr : this.getFeaturesInSchemaTypeAndVariations(entity).filter(SimpleFeature).filter[f | f.type instanceof SimpleAggregateTarget])
      result.addAll(this.getReferencedEntities(this.getAggregatedEntityDecl(aggr.type as SimpleAggregateTarget)))

    return result
  }
  
  def List<EntityDecl> getReferencedEntities(RelationshipDecl entity)
  {
  	val result = new ArrayList<EntityDecl>()
  	
  	for (ref : this.getFeaturesInSchemaType(entity).filter(SimpleFeature).filter[f | f.type instanceof SimpleReferenceTarget])
      result.add((ref.type as SimpleReferenceTarget).ref)

    return result
  }

  /**
   * Returns a List of Entities that have an Aggregate aggregating the given entity or one of its Variations
   */
  def List<EntityDecl> getAggregatingEntities(EntityDecl entity)
  {
    return EcoreUtil2.eAllOfType(EcoreUtil2.getContainerOfType(entity, AthenaSchema), SimpleAggregateTarget)
      .filter[a | a.aggr.contains(entity) || this.getVariations(entity).contains(a.aggr)]
      .map[a | EcoreUtil2.getContainerOfType(a, EntityDecl)].toList
  }
}
