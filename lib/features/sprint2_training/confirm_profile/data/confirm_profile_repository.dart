abstract class ConfirmProfileRepository {

  //Fetching a profile needs to be async, no guranteed response time, returns the profile username
  Future<String?> getProfileName();

  //TODO: Implement image functionality as directed by Thabang
  Future<String?> getProfileImage();

}