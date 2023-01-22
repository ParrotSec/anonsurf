using Gtk;


public class AnonSurfDialogAbout: AboutDialog {
  public AnonSurfDialogAbout() {
    const string authors[] = {
      "Lorenzo \"Palinuro\" Faletra",
      "Nong Hoang \"DmKnght\" Tu",
      "Lisetta \"Sheireen\" Ferrero",
      "Francesco \"Mibofra\" Bonanno",
      "Manuel \"Serverket\" Hernandez",
    };
    const string artists[] = {
      "Federica \"marafed\" Marasà",
      "David \"mcder3\" Linares",
    };

    this.set_icon_name("anonsurf");
    this.set_logo_icon_name("anonsurf");
    this.set_program_name("AnonSurf");
    this.set_version("5.0.0"); // FIXME use correct version of anonsurf
    this.set_artists(artists);
    this.set_authors(authors);
    this.set_comments("Anonymous Toolkit of ParrotOS");
    this.set_copyright("Copyright © 2013 - 2020 Lorenzo \"Palinuro\" Faletra\nCopyright © 2022 Parrot Security CIC");
    this.set_license_type(GPL_3_0);
    this.set_website("https://nest.parrot.sh/packages/tools/anonsurf");
    this.set_website_label("Gitlab Source");
  }
}
