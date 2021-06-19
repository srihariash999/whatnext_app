import 'package:tmdb_api/tmdb_api.dart';
import 'package:whatnext/constants/api_keys.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class TmdbService {
  TMDB tmdb = TMDB(ApiKeys('$v3', '$v4'));

  var client = http.Client();

  fetchPopularMoviesFromTmdb(int page) async {
    return await tmdb.v3.movies.getPouplar(page: page ?? 1);
  }

  fetchTopRatedMoviesFromTmdb(int page) async {
    return await tmdb.v3.movies.getTopRated(page: page ?? 1);
  }

  fetchPopularTvShowsFromTmdb(int page) async {
    return await tmdb.v3.tv.getPouplar(page: page ?? 1);
  }

  fetchTopRatedTvShowsFromTmdb(int page) async {
    return await tmdb.v3.tv.getTopRated(page: page ?? 1);
  }

  fetchSearchResultsFromTmdb(String query) async {
    return await tmdb.v3.search.queryMulti(query);
  }

  fetchMovieDetails(int id) async {
    return await tmdb.v3.movies.getDetails(id);
  }

  fetchTvShowDetails(int id) async {
    return await tmdb.v3.tv.getDetails(id);
  }

  fetchMovieCast(int id) async {
    return await tmdb.v3.movies.getCredits(id);
  }

  fetchTvCast(int id) async {
    return await tmdb.v3.tv.getCredits(id);
  }

  fetchSimilarMovies(int id) async {
    return await tmdb.v3.movies.getSimilar(id);
  }

  fetchMovieRecommendations(int id) async {
    return await tmdb.v3.movies.getRecommended(id);
  }

  fetchSimilarTvShows(int id) async {
    return await tmdb.v3.tv.getSimilar(id);
  }

  fetchTvShowRecommendations(int id) async {
    return await tmdb.v3.tv.getRecommendations(id);
  }

  fetchVideosofMovie(int movieId) async {
    return await tmdb.v3.movies.getVideos(movieId);
  }

  fetchMoviePictures(int movieId) async {
    return await tmdb.v3.movies
        .getImages(movieId, includeImageLanguage: 'en,null');
  }

  fetchReviews(int id, String type) async {
    if (type == 'movie') {
      return await tmdb.v3.movies.getReviews(id);
    } else {
      return await tmdb.v3.tv.getReviews(id);
    }
  }

  fetchTvPictures(int tvId) async {
    try {
      var uri = Uri.parse(
          'https://api.themoviedb.org/3/tv/$tvId/images?api_key=$v3&include_image_language=en,null');
      var response = await client.get(uri);
      var jsonResponse = convert.jsonDecode(response.body);
      return jsonResponse;
    } catch (e) {
      print(" error while getting tv images");
      return {
        'id': 0,
        'backdrops': [],
        'posters': [],
      };
    }
  }
}
