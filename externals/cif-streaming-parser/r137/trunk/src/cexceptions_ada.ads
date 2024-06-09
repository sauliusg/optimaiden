pragma Ada_2012;

pragma Style_Checks (Off);
pragma Warnings (Off, "-gnatwu");

with Interfaces.C.Strings; use Interfaces.C.Strings;
with System;

package CExceptions_Ada is

    type Error_Code_T is null record;

    type Error_Code_T_Access is access all Error_Code_T;

end CExceptions_Ada;

pragma Style_Checks (On);
pragma Warnings (On, "-gnatwu");
