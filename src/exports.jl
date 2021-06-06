# TODO - should we just rename the Core* structs?
const Client = CoreClient
const Session = CoreSession
const Transaction = CoreTransaction
const Database = CoreDatabase
const DatabaseManager = CoreDatabaseManager

# general
export Client, Session, Transaction, Database, DatabaseManager
export TypeDBOptions

# constants
export VALUE_TYPE

# concepts
# - ConceptManager.jl functions requires these types for dispatch
export AttributeType, EntityType, RelationType, RoleType, ThingType
export Attribute, Entity, Relation, Thing
export ConceptManager

# functions (listed in alphabetical order)
export get_instances,
       get_owns,
       get_owners,
       get_plays,
       get_regex,
       get_rule,
       get_rules,
       get_subtypes,
       get_supertype,
       get_supertypes,
       set_abstract,
       set_label,
       set_owns,
       set_plays,
       set_regex,
       set_supertype,
       unset_abstract

# others
export contains_database

