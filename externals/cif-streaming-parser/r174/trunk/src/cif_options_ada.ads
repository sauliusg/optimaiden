pragma Ada_2012;

pragma Style_Checks (Off);
pragma Warnings (Off, "-gnatwu");

with Interfaces.C; use Interfaces.C;

package Cif_Options_Ada is

    subtype Cif_Option_T is unsigned;

    function Cif_Option_Default return Cif_Option_T
        with Import => True,
        Convention => C,
        External_Name => "cif_option_default";

end Cif_Options_Ada;

pragma Style_Checks (On);
pragma Warnings (On, "-gnatwu");
