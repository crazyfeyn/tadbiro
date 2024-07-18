class StaticVariables {
  static List<String> likes = [];

  void addLike(String eventId) {
    likes.add(eventId);
  }

  void removeLike(String eventId) {
    likes.remove(eventId);
  }
}
