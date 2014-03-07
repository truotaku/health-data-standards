# ERROR #001
Element '{urn:hl7-org:v3}observationReference': This element is not expected. Expected is one of ( {urn:hl7-org:v3}criteriaReference, {urn:hl7-org:v3}actCriteria, {urn:hl7-org:v3}substanceAdministrationCriteria, {urn:hl7-org:v3}observationCriteria, {urn:hl7-org:v3}encounterCriteria, {urn:hl7-org:v3}procedureCriteria, {urn:hl7-org:v3}supplyCriteria, {urn:hl7-org:v3}grouperCriteria ).

## FIX
Replace "observationReference" with "criteriaReference"

## REPRESENTATIVE CHANGE:
    -            <observationReference moodCode="EVN" classCode="OBS">
    +            <criteriaReference moodCode="EVN" classCode="OBS">
                   <id root="2.16.840.1.113883.3.100.1" extension="<%= section_name(
    -            </observationReference>
    +            </criteriaReference>

## GIT STATUS:
    modified:   lib/hqmf-generator/characteristic_criteria.xml.erb
    modified:   lib/hqmf-generator/condition_criteria.xml.erb
    modified:   lib/hqmf-generator/observation_criteria.xml.erb
    modified:   lib/hqmf-generator/source.xml.erb
    modified:   lib/hqmf-generator/specific_occurrence.xml.erb

-------------------------------------------------------------------------------

# ERROR #002
Element '{urn:hl7-org:v3}id': Character content is not allowed, because the content type is empty.

##FIX
Remove "item" child from "id" and put "item" attributes into "id"

## REPRESENTATIVE CHANGE:
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
Replace "encounterReference" with "criteriaReference"

## REPRESENTATIVE CHANGE:
    -            <encounterReference moodCode="EVN" classCode="ENC">
    +            <criteriaReference moodCode="EVN" classCode="ENC">
                   <id root="2.16.840.1.113883.3.100.1" extension="<%= section_name(
    -            </encounterReference>
    +            </criteriaReference>

## GIT STATUS:
    modified:   lib/hqmf-generator/encounter_criteria.xml.erb


-------------------------------------------------------------------------------

# ERROR #000


##FIX


## REPRESENTATIVE CHANGE:


## GIT STATUS


-------------------------------------------------------------------------------

