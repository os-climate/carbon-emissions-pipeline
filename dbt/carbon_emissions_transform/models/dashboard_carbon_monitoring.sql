{{
  config(
    materialized = 'view',
    view_security = 'invoker'
  )
}}

with source_data as (
    SELECT pod_namespace, pod_name, osc_datacommons_dev.sandbox.dashboard_pod_energy."month",
    osc_datacommons_dev.sandbox.dashboard_pod_energy."day", osc_datacommons_dev.sandbox.dashboard_pod_energy."hour", avg_pod_energy,
    osc_datacommons_dev.sandbox.dashboard_carbon_intensity.region, osc_datacommons_dev.sandbox.dashboard_carbon_intensity.carbon_intensity,
    osc_datacommons_dev.sandbox.dashboard_carbon_intensity.unit_value, avg_pod_energy / 3600000 as avg_pod_energy_kwh, 
    avg_pod_energy / 3600000 * osc_datacommons_dev.sandbox.dashboard_carbon_intensity.carbon_intensity AS gCO2eq         
FROM osc_datacommons_dev.sandbox.dashboard_pod_energy
INNER JOIN osc_datacommons_dev.sandbox.dashboard_carbon_intensity
ON osc_datacommons_dev.sandbox.dashboard_pod_energy."month" = osc_datacommons_dev.sandbox.dashboard_carbon_intensity."month"
AND osc_datacommons_dev.sandbox.dashboard_pod_energy."day" = osc_datacommons_dev.sandbox.dashboard_carbon_intensity."day"
AND  osc_datacommons_dev.sandbox.dashboard_pod_energy."hour" = osc_datacommons_dev.sandbox.dashboard_carbon_intensity."hour"
)

select * from source_data