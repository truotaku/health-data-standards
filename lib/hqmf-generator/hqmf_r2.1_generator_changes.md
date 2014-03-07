# ERROR #001
Element '{urn:hl7-org:v3}observationReference': This element is not expected. Expected is one of ( {urn:hl7-org:v3}criteriaReference, {urn:hl7-org:v3}actCriteria, {urn:hl7-org:v3}substanceAdministrationCriteria, {urn:hl7-org:v3}observationCriteria, {urn:hl7-org:v3}encounterCriteria, {urn:hl7-org:v3}procedureCriteria, {urn:hl7-org:v3}supplyCriteria, {urn:hl7-org:v3}grouperCriteria ).

## FIX
Replace `observationReference` with `criteriaReference` in templates.

As well as the fix to the specific templates, there are also generic reference-related templates that need
to be modified to always use `criteriaReference`.

## REPRESENTATIVE CHANGES
    -            <observationReference moodCode="EVN" classCode="OBS">
    +            <criteriaReference moodCode="EVN" classCode="OBS">
                   <id root="2.16.840.1.113883.3.100.1" extension="<%= section_name(
    -            </observationReference>
    +            </criteriaReference>

and

    -            <<%= reference_element_name(reference.id) %>Reference moodCode="EVN
    +            <criteriaReference moodCode="EVN" classCode="<%= reference_type_nam
                   <id root="2.16.840.1.113883.3.100.1" extension="<%= reference.id
    -            </<%= reference_element_name(reference.id) %>Reference>
    +            </criteriaReference>

## GIT STATUS:
    modified:   lib/hqmf-generator/characteristic_criteria.xml.erb
    modified:   lib/hqmf-generator/condition_criteria.xml.erb
    modified:   lib/hqmf-generator/observation_criteria.xml.erb
    modified:   lib/hqmf-generator/source.xml.erb
    modified:   lib/hqmf-generator/specific_occurrence.xml.erb

and

    modified:   lib/hqmf-generator/precondition.xml.erb
    modified:   lib/hqmf-generator/reference.xml.erb

-------------------------------------------------------------------------------

# ERROR #002
Element '{urn:hl7-org:v3}id': Character content is not allowed, because the content type is empty.

##FIX
Remove `item` child from `id` and put `item's` attributes into `id`

## REPRESENTATIVE CHANGE
    -          <id>
    -            <item root="2.16.840.1.113883.3.100.1" extension="<%= criteria.id %
    -          </id>
    +          <id root="2.16.840.1.113883.3.100.1" extension="<%= criteria.id %>"/>

## GIT STATUS
    modified:   lib/hqmf-generator/characteristic_criteria.xml.erb
    modified:   lib/hqmf-generator/condition_criteria.xml.erb
    modified:   lib/hqmf-generator/encounter_criteria.xml.erb
    modified:   lib/hqmf-generator/observation_criteria.xml.erb
    modified:   lib/hqmf-generator/procedure_criteria.xml.erb
    modified:   lib/hqmf-generator/substance_criteria.xml.erb
    modified:   lib/hqmf-generator/supply_criteria.xml.erb
    modified:   lib/hqmf-generator/variable_criteria.xml.erb

-------------------------------------------------------------------------------

# ERROR #003
Element '{urn:hl7-org:v3}encounterReference': This element is not expected. Expected is one of ( {urn:hl7-org:v3}realmCode, {urn:hl7-org:v3}typeId, {urn:hl7-org:v3}templateId, {urn:hl7-org:v3}criteriaReference ).

## FIX
Replace `encounterReference` with `criteriaReference`

## CHANGE
    -            <encounterReference moodCode="EVN" classCode="ENC">
    +            <criteriaReference moodCode="EVN" classCode="ENC">
                   <id root="2.16.840.1.113883.3.100.1" extension="<%= section_name(
    -            </encounterReference>
    +            </criteriaReference>

## GIT STATUS:
    modified:   lib/hqmf-generator/encounter_criteria.xml.erb

-------------------------------------------------------------------------------

# ERROR #004
Element '{urn:hl7-org:v3}pauseQuantity', attribute '{http://www.w3.org/2001/XMLSchema-instance}type': The type definition '{urn:hl7-org:v3}IVL_PQ', specified by xsi:type, is blocked or not validly derived from the type definition of the element declaration.

##FIX
Do not generate the `type` attribute on `pauseQuantity` elements.

## CHANGES
                 <%- if relationship.range -%>
    -            <%= xml_for_value(relationship.range, 'pauseQuantity') %>
    +            <%= xml_for_value(relationship.range, 'pauseQuantity', false) %>
                 <%- end -%>

and

     <%- if value.class==HQMF::Range -%>
    -  <<%= name %> xsi:type="<%= value.type %>">
    +  <<%= name %> <%= "xsi:type=\"#{value.type}\"" if include_type %>>
         <%= xml_for_value(value.low, 'low', false) if value.low -%>
         <%= xml_for_value(value.high, 'high', false) if value.high -%>
       </<%= name %>>

## GIT STATUS
    modified:   lib/hqmf-generator/temporal_relationship.xml.erb
    modified:   lib/hqmf-generator/value.xml.erb

-------------------------------------------------------------------------------

# ERROR #005
Element '{urn:hl7-org:v3}procedureReference': This element is not expected. Expected is one of ( {urn:hl7-org:v3}realmCode, {urn:hl7-org:v3}typeId, {urn:hl7-org:v3}templateId, {urn:hl7-org:v3}criteriaReference ).

##FIX
Replace `procedureReference` with `criteriaReference`

## CHANGE
    -            <procedureReference moodCode="EVN" classCode="PROC">
    +            <criteriaReference moodCode="EVN" classCode="PROC">
                   <id root="2.16.840.1.113883.3.100.1" extension="<%= section_name(
    -            </procedureReference>
    +            </criteriaReference>

## GIT STATUS
    modified:   lib/hqmf-generator/procedure_criteria.xml.erb

-------------------------------------------------------------------------------

# ERROR #006
Element '{urn:hl7-org:v3}high': This element is not expected. Expected is one of ( {urn:hl7-org:v3}expression, {urn:hl7-org:v3}originalText, {urn:hl7-org:v3}uncertainty, {urn:hl7-org:v3}uncertainRange, {urn:hl7-org:v3}translation ).

##FIX
Modify generation of `pauseQuantity` to have a child `uncertainRange` element containing the range information.

## CHANGE
_WARNING: We should probably not be using the element name as a condition, but there was nothing much else to go off in the model._
_This needs to be revisited._

     <%- if value.class==HQMF::Range -%>
       <<%= name %> <%= "xsi:type=\"#{value.type}\"" if include_type %>>
    -    <%= xml_for_value(value.low, 'low', false) if value.low -%>
    -    <%= xml_for_value(value.high, 'high', false) if value.high -%>
    +    <%- # WARNING: Hacky Fix That Must Be Looked At Again! -%>
    +    <%- if name == 'pauseQuantity' -%>
    +      <uncertainRange <%= "lowClosed=\"true\"" if value.low && value.low.inclus
    +        <%= xml_for_value(value.low, 'low') if value.low -%>
    +        <%= xml_for_value(value.high, 'high') if value.high -%>
    +      </uncertainRange>
    +    <%- else -%>
    +      <%= xml_for_value(value.low, 'low', false) if value.low -%>
    +      <%= xml_for_value(value.high, 'high', false) if value.high -%>
    +    <%- end -%>
       </<%= name %>>

## GIT STATUS
    modified:   lib/hqmf-generator/value.xml.erb

-------------------------------------------------------------------------------

# ERROR #007
Element '{urn:hl7-org:v3}substanceAdministrationReference': This element is not expected. Expected is one of ( {urn:hl7-org:v3}realmCode, {urn:hl7-org:v3}typeId, {urn:hl7-org:v3}templateId, {urn:hl7-org:v3}criteriaReference ).

##FIX
Replace `substanceAdministrationReference` with `criteriaReference`.

## CHANGE
    -            <substanceAdministrationReference moodCode="EVN" classCode="SBADM">
    +            <criteriaReference moodCode="EVN" classCode="SBADM">
                   <id root="2.16.840.1.113883.3.100.1" extension="<%= section_name(
    -            </substanceAdministrationReference>
    +            </criteriaReference>

## GIT STATUS
    modified:   lib/hqmf-generator/substance_criteria.xml.erb

-------------------------------------------------------------------------------

# ERROR #008

##FIX

## REPRESENTATIVE CHANGE

## GIT STATUS

-------------------------------------------------------------------------------

# ERROR #009


##FIX


## REPRESENTATIVE CHANGE


## GIT STATUS


-------------------------------------------------------------------------------

# ERROR #010


##FIX


## REPRESENTATIVE CHANGE


## GIT STATUS


-------------------------------------------------------------------------------

# ERROR #011


##FIX


## REPRESENTATIVE CHANGE


## GIT STATUS


-------------------------------------------------------------------------------

# ERROR #012


##FIX


## REPRESENTATIVE CHANGE


## GIT STATUS


-------------------------------------------------------------------------------

# ERROR #013


##FIX


## REPRESENTATIVE CHANGE


## GIT STATUS


-------------------------------------------------------------------------------

# ERROR #014


##FIX


## REPRESENTATIVE CHANGE


## GIT STATUS


-------------------------------------------------------------------------------

# ERROR #015


##FIX


## REPRESENTATIVE CHANGE


## GIT STATUS


-------------------------------------------------------------------------------

# ERROR #016


##FIX


## REPRESENTATIVE CHANGE


## GIT STATUS


-------------------------------------------------------------------------------

# ERROR #017


##FIX


## REPRESENTATIVE CHANGE


## GIT STATUS


-------------------------------------------------------------------------------

# ERROR #018


##FIX


## REPRESENTATIVE CHANGE


## GIT STATUS


-------------------------------------------------------------------------------

# ERROR #019


##FIX


## REPRESENTATIVE CHANGE


## GIT STATUS


-------------------------------------------------------------------------------

# ERROR #020


##FIX


## REPRESENTATIVE CHANGE


## GIT STATUS


-------------------------------------------------------------------------------

# ERROR #021


##FIX


## REPRESENTATIVE CHANGE


## GIT STATUS


-------------------------------------------------------------------------------

# ERROR #022


##FIX


## REPRESENTATIVE CHANGE


## GIT STATUS


-------------------------------------------------------------------------------

# ERROR #023


##FIX


## REPRESENTATIVE CHANGE


## GIT STATUS


-------------------------------------------------------------------------------

# ERROR #024


##FIX


## REPRESENTATIVE CHANGE


## GIT STATUS


-------------------------------------------------------------------------------

# ERROR #025


##FIX


## REPRESENTATIVE CHANGE


## GIT STATUS


-------------------------------------------------------------------------------

# ERROR #026


##FIX


## REPRESENTATIVE CHANGE


## GIT STATUS


-------------------------------------------------------------------------------

# ERROR #027


##FIX


## REPRESENTATIVE CHANGE


## GIT STATUS


-------------------------------------------------------------------------------

# ERROR #028


##FIX


## REPRESENTATIVE CHANGE


## GIT STATUS


-------------------------------------------------------------------------------

# ERROR #029


##FIX


## REPRESENTATIVE CHANGE


## GIT STATUS


-------------------------------------------------------------------------------

# ERROR #030


##FIX


## REPRESENTATIVE CHANGE


## GIT STATUS


-------------------------------------------------------------------------------

# ERROR #031


##FIX


## REPRESENTATIVE CHANGE


## GIT STATUS


-------------------------------------------------------------------------------

# ERROR #032


##FIX


## REPRESENTATIVE CHANGE


## GIT STATUS


-------------------------------------------------------------------------------

# ERROR #033


##FIX


## REPRESENTATIVE CHANGE


## GIT STATUS


-------------------------------------------------------------------------------

# ERROR #034


##FIX


## REPRESENTATIVE CHANGE


## GIT STATUS


-------------------------------------------------------------------------------

# ERROR #035


##FIX


## REPRESENTATIVE CHANGE


## GIT STATUS


-------------------------------------------------------------------------------


