import 'package:tmdb_api/tmdb_api.dart';
import 'package:whatnext/constants/api_keys.dart';

class TmdbService {
  TMDB tmdb = TMDB(ApiKeys('$v3', '$v4'));

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
}
